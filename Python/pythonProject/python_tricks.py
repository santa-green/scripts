# Python trick: Create a simple paper-folding simulator
def fold_paper(size_cm, folds):
    for _ in range(folds):
        size_cm = [s/2 for s in size_cm]
    return size_cm

# Example: Start with 15x15 cm, fold 3 times
print(fold_paper([15, 15], 3))  # Output: [1.875, 1.875]
# Great for simulating how many folds before paper gets too small!
