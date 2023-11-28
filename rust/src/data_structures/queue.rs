pub struct ArrayQueue<T> {
    array: Vec<T>,
    front_idx: i32,
    size: i32,
    capacity: i32
}

impl<T> Default for ArrayQueue<T> {
    fn default() -> Self {
        Self::new(50)
    }
}

impl<T> ArrayQueue<T> {
    pub fn new(capacity: i32) -> Self {
        return Self {
            array: Vec::<T>::with_capacity(capacity as usize),
            front_idx: 0,
            size: 0,
            capacity,
        }
    }
    fn capacity(&self) -> i32 {
        return self.capacity
    }

    fn size(&self) -> i32 {
        return self.size
    }

    fn is_empty(&self) -> bool {
        return self.size == 0
    }
}

#[cfg(test)]
mod tests {
    use super::ArrayQueue;

    #[test]
    fn test_queue_construct() {
        let queue: ArrayQueue<u8> = ArrayQueue::default();
        assert!(queue.capacity() == 50);
        let queue: ArrayQueue<i32> = ArrayQueue::default();
        assert!(queue.capacity() == 50);
    }
}