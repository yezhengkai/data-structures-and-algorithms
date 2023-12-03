use std::mem::size_of;

pub struct QueueWithVec<T> {
    array: Vec<T>,
    head: usize,
    len: usize,
    capacity: usize,
}

// TODO: refer to https://doc.rust-lang.org/src/alloc/collections/vec_deque/mod.rs.html#108-120
// impl<T: Clone> Clone for QueueWithVec<T> {
//     fn clone(&self) -> Self {
//         let mut queue = Self::with_capacity_in(self.len());
//         queue.extend(self.iter().cloned());
//         queue
//     }

//     fn clone_from(&mut self, other: &Self) {
//         self.clear();
//         self.extend(other.iter().cloned());
//     }
// }

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
        if size_of::<T>() == 0 { // equivalent to T::IS_ZST (need use `use core::mem::SizedTypeProperties;` or `use std::mem::SizedTypeProperties;`)
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
}
