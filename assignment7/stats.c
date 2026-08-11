#include <stdio.h>
#include <stdlib.h>

// Calculates the average of all values in the array
double calculate_mean(int arr[], int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) sum += arr[i];
    return (double)sum / n;
}

// Comparator used by qsort for ascending order
int compare(const void *a, const void *b) {
    return (*(int*)a - *(int*)b);
}

// Sorts a copy of the array and returns the middle value(s) average
double calculate_median(int arr[], int n) {
    int *sorted = malloc(n * sizeof(int));
    for (int i = 0; i < n; i++) sorted[i] = arr[i];
    qsort(sorted, n, sizeof(int), compare);

    double median;
    if (n % 2 == 0)
        median = (sorted[n/2 - 1] + sorted[n/2]) / 2.0;
    else
        median = sorted[n/2];

    free(sorted);
    return median;
}

// Counts frequency of each value and prints the most frequent one(s)
void calculate_mode(int arr[], int n) {
    int *counts = calloc(n, sizeof(int));
    int max_count = 0;

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            if (arr[j] == arr[i]) counts[i]++;
        }
        if (counts[i] > max_count) max_count = counts[i];
    }

    printf("Mode(s): ");
    for (int i = 0; i < n; i++) {
        if (counts[i] == max_count) {
            int already_printed = 0;
            for (int k = 0; k < i; k++) {
                if (arr[k] == arr[i]) already_printed = 1;
            }
            if (!already_printed) printf("%d ", arr[i]);
        }
    }
    printf("\n");
    free(counts);
}

int main() {
    int data[] = {4, 8, 2, 8, 6, 4, 8, 1};
    int n = sizeof(data) / sizeof(data[0]);

    printf("Data: ");
    for (int i = 0; i < n; i++) printf("%d ", data[i]);
    printf("\n");

    printf("Mean: %.2f\n", calculate_mean(data, n));
    printf("Median: %.2f\n", calculate_median(data, n));
    calculate_mode(data, n);

    return 0;
}