package main

import (
	"encoding/csv"
	"fmt"
	"log"
	"os"
	"strconv"
	"sync"
	"time"
)

// ---------- RideRequest ----------

type RideRequest struct {
	ID             int
	PickupLocation string
}

// ---------- RideRequestQueue (channel-backed shared queue) ----------

type RideRequestQueue struct {
	tasks chan RideRequest
}

func NewRideRequestQueue(capacity int) *RideRequestQueue {
	return &RideRequestQueue{tasks: make(chan RideRequest, capacity)}
}

func (q *RideRequestQueue) AddTask(r RideRequest) {
	q.tasks <- r
}

func (q *RideRequestQueue) Close() {
	close(q.tasks)
}

// GetTask blocks until a task is available or the queue is closed and drained,
// mirroring the Java queue's getTask() returning null when empty.
func (q *RideRequestQueue) GetTask() (RideRequest, bool) {
	r, ok := <-q.tasks
	return r, ok
}

// ---------- RideResult ----------

type RideResult struct {
	RideRequestID int
	Outcome       string
}

// ---------- RideResultStore (CSV-backed shared output resource) ----------

type RideResultStore struct {
	mu     sync.Mutex
	nextID int
	file   *os.File
	writer *csv.Writer
}

func NewRideResultStore(path string) (*RideResultStore, error) {
	file, err := os.Create(path)
	if err != nil {
		return nil, fmt.Errorf("failed to create result file: %w", err)
	}

	writer := csv.NewWriter(file)
	if err := writer.Write([]string{"id", "rideRequestId", "outcome"}); err != nil {
		file.Close()
		return nil, fmt.Errorf("failed to write header: %w", err)
	}
	writer.Flush()

	return &RideResultStore{file: file, writer: writer}, nil
}

// Save persists a result. Synchronized with a mutex since multiple driver
// goroutines write to the same file concurrently.
func (s *RideResultStore) Save(result RideResult) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.nextID++
	row := []string{strconv.Itoa(s.nextID), strconv.Itoa(result.RideRequestID), result.Outcome}
	if err := s.writer.Write(row); err != nil {
		return fmt.Errorf("failed to write result row: %w", err)
	}
	s.writer.Flush()
	return s.writer.Error()
}

func (s *RideResultStore) Close() error {
	s.writer.Flush()
	return s.file.Close()
}

// ---------- DriverWorker (goroutine) ----------

func driverWorker(id int, queue *RideRequestQueue, store *RideResultStore, wg *sync.WaitGroup) {
	defer wg.Done()
	defer func() {
		if r := recover(); r != nil {
			log.Printf("Driver-%d recovered from panic: %v", id, r)
		}
	}()

	log.Printf("Driver-%d started", id)

	for {
		request, ok := queue.GetTask()
		if !ok {
			break
		}
		processRide(id, request, store)
	}

	log.Printf("Driver-%d completed", id)
}

func processRide(driverID int, request RideRequest, store *RideResultStore) {
	time.Sleep(200 * time.Millisecond) // simulate ride matching / trip processing time

	result := RideResult{
		RideRequestID: request.ID,
		Outcome:       fmt.Sprintf("Completed ride from %s", request.PickupLocation),
	}

	if err := store.Save(result); err != nil {
		log.Printf("Driver-%d failed to save result for ride %d: %v", driverID, request.ID, err)
		return
	}

	log.Printf("Driver-%d completed ride request %d", driverID, request.ID)
}

// ---------- main (RideMatchingService equivalent) ----------

func main() {
	log.SetFlags(log.Ltime)
	if err := run(); err != nil {
		log.Fatalf("ride matching run failed: %v", err)
	}
}

// run executes the full ride-matching pipeline and returns an error instead
// of exiting directly, so deferred cleanup (closing the result file) always
// runs, even if a later step fails.
func run() error {
	rideRequestCount, driverCount := 20, 5

	queue := NewRideRequestQueue(rideRequestCount)
	for i := 1; i <= rideRequestCount; i++ {
		queue.AddTask(RideRequest{ID: i, PickupLocation: fmt.Sprintf("Zone-%d", i)})
	}
	queue.Close()

	store, err := NewRideResultStore("ride_results.csv")
	if err != nil {
		return fmt.Errorf("failed to initialize result store: %w", err)
	}
	defer func() {
		if closeErr := store.Close(); closeErr != nil {
			log.Printf("error closing result store: %v", closeErr)
		}
	}()

	var wg sync.WaitGroup
	for i := 1; i <= driverCount; i++ {
		wg.Add(1)
		go driverWorker(i, queue, store, &wg)
	}
	wg.Wait()

	fmt.Printf("Processed %d ride requests with %d drivers\n", rideRequestCount, driverCount)
	return nil
}