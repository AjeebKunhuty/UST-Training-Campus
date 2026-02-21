import unittest
from store import Store

class TestStore(unittest.TestCase):
    def test_checkout_more_than_available(self):
        store = Store()
        store.stockup('Paracetamol', 25)
        with self.assertRaises(ValueError):
            store.checkout('Paracetamol', 30)

    def test_checkout_unavailable(self):
        store = Store()
        store.stockup('Paracetamol', 25)
        with self.assertRaises(KeyError):
            store.checkout('Dolo', 3)

    def test_checkout_valid(self):
        store = Store()
        store.stockup('Paracetamol', 25)
        store.checkout('Paracetamol', 20)
        self.assertEqual(store.items['Paracetamol'], 5)

    def test_stockup_negative(self):
        store = Store()
        with self.assertRaises(ValueError):
            store.stockup('Paracetamol', -1)

    def test_checkout_negative(self):
        store = Store()
        store.stockup('Paracetamol', 20)
        with self.assertRaises(ValueError):
            store.checkout('Paracetamol', -20)

    def test_stockup_item_type(self):
        store = Store()
        with self.assertRaises(TypeError):
            store.stockup(('Dolo',), 20)

    def test_stockup_count_type(self):
        store = Store()
        with self.assertRaises(TypeError):
            store.stockup('Dolo', 20.0)
    
    def test_checkout_item_type(self):
        store = Store()
        store.stockup('Dolo', 20)
        with self.assertRaises(TypeError):
            store.stockup(('Dolo',), 20)
            # store.stockup(('Dolo'), 20)

    def test_checkout_count_type(self):
        store = Store()
        store.stockup('Dolo', 20)
        with self.assertRaises(TypeError):
            store.stockup('Dolo', 20.0)
    
    

if __name__ == '__main__':
    unittest.main()