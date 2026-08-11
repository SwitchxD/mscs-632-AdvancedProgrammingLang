from collections import Counter

class StatisticsCalculator:
    """Encapsulates mean, median, and mode calculations for a list of integers."""

    def __init__(self, data):
        self.data = data

    def mean(self):
        """Returns the average of the dataset."""
        return sum(self.data) / len(self.data)

    def median(self):
        """Returns the middle value of the sorted dataset."""
        sorted_data = sorted(self.data)
        n = len(sorted_data)
        mid = n // 2
        if n % 2 == 0:
            return (sorted_data[mid - 1] + sorted_data[mid]) / 2
        return sorted_data[mid]

    def mode(self):
        """Returns the most frequently occurring value(s) using a dictionary of counts."""
        counts = Counter(self.data)
        max_count = max(counts.values())
        return [num for num, cnt in counts.items() if cnt == max_count]


if __name__ == "__main__":
    data = [4, 8, 2, 8, 6, 4, 8, 1]
    calc = StatisticsCalculator(data)

    print(f"Data: {data}")
    print(f"Mean: {calc.mean():.2f}")
    print(f"Median: {calc.median():.2f}")
    print(f"Mode(s): {calc.mode()}")