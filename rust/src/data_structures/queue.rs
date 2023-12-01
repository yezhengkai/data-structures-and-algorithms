pub struct QueueWithVec<T> {
    array: Vec<T>,
    front_idx: i32,
    size: i32,
    capacity: i32
}

impl<T> Default for QueueWithVec<T> {
    fn default() -> Self {
        Self::new(50)
    }
}

impl<T> QueueWithVec<T> {
    pub fn new(capacity: i32) -> Self {
        return Self {
            array: Vec::<T>::with_capacity(capacity as usize),
            front_idx: 0,
            size: 0,
            capacity,
        }
    }
    pub fn capacity(&self) -> i32 {
        return self.capacity
    }

    pub fn size(&self) -> i32 {
        return self.size
    }

    pub fn is_empty(&self) -> bool {
        return self.size == 0
    }
}

#[cfg(test)]
mod tests {
    use super::QueueWithVec;

    #[test]
    fn test_queue_construct() {
        let queue: QueueWithVec<u8> = QueueWithVec::default();
        assert!(queue.capacity() == 50);
        let queue: QueueWithVec<i32> = QueueWithVec::default();
        assert!(queue.capacity() == 50);
    }
}