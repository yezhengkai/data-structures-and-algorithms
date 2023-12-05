use std::mem::size_of;

pub struct QueueWithVec<T> {
    array: Vec<T>,
    head: usize,
    len: usize,
    // `usize`: The pointer-sized unsigned integer type.
    // The size of this primitive is how many bytes it takes to reference any location in memory. For example, on a 32 bit target, this is 4 bytes and on a 64 bit target, this is 8 bytes.
    capacity: usize,
}

impl<T> Default for QueueWithVec<T> {
    /// Creates an empty queue.
    fn default() -> Self {
        Self::new(50)
    }
}

impl<T> QueueWithVec<T> {
    pub fn new(capacity: usize) -> Self {
        return Self {
            array: Vec::<T>::with_capacity(capacity),
            head: 0,
            len: 0,
            capacity,
        };
    }

    pub fn capacity(&self) -> usize {
        if size_of::<T>() == 0 {
            // equivalent to T::IS_ZST (need use `use core::mem::SizedTypeProperties;` or `use std::mem::SizedTypeProperties;`)
            usize::MAX
        } else {
            self.array.capacity()
        }
    }

    pub fn len(&self) -> usize {
        return self.len;
    }

    pub fn is_empty(&self) -> bool {
        return self.len == 0;
    }

    fn is_full(&self) -> bool {
        self.len == self.capacity()
    }
    fn grow(&mut self) {
        debug_assert!(self.is_full());
        let old_cap = self.capacity();
        self.array.reserve(old_cap);
        debug_assert!(!self.is_full());
    }

    /// Appends an element to the back of the queue.
    /// Time complexity: O(1)
    pub fn push(&mut self, value: T) {
        // TODO: ref: https://stackoverflow.com/questions/71989694/create-an-empty-vector-of-size-n-and-not-fill-it-with-anything
        if self.is_full() {
            self.grow();
        }
        // let rear = (self.head + self.len) % self.capacity;
        // self.array[rear] = value;
        self.array.push(value);
        self.len += 1;
    }

    /// Accessing the first element in the queue
    /// Time complexity: O(1)
    pub fn peek(&self) -> Option<&T> {
        if self.is_empty() {
            None
        } else {
            Some(&self.array[self.head])
        }
    }
}

#[cfg(test)]
mod tests {
    use super::QueueWithVec;

    #[test]
    fn construct() {
        let queue: QueueWithVec<u8> = QueueWithVec::default();
        assert!(queue.capacity() == 50);
        let queue: QueueWithVec<i32> = QueueWithVec::default();
        assert!(queue.capacity() == 50);
        let queue: QueueWithVec<f32> = QueueWithVec::new(10);
        assert!(queue.capacity() == 10);
    }

    #[test]
    fn len() {
        let queue: QueueWithVec<i64> = QueueWithVec::default();
        assert_eq!(queue.len(), 0);
        assert!(queue.is_empty());
        assert!(!queue.is_full());
        assert!(queue.capacity() != 0)
    }

    #[test]
    fn push_pop_peek() {
        let mut queue: QueueWithVec<i64> = QueueWithVec::new(1);
        assert_eq!(queue.peek(), None);
        queue.push(1);
        assert!(queue.capacity() == 1);
        queue.push(2);
        assert!(queue.capacity() >= 2);
        assert_eq!(queue.peek(), Some(&1));
    }
}
