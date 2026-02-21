class Store:
    def __init__(self):
        self.items = { }

    def stockup(self, item, count):
        if not isinstance(count, int):
            raise TypeError("Count must be an integer")
        
        if not isinstance(item, str):
            raise TypeError("Item name must be a string")

        if count <= 0:
            raise ValueError("Commodity count must be a natural number")
        
        self.items[item] = count if item not in self.items else self.items[item] + count

    def checkout(self, item, count):
        if not isinstance(count, int):
            raise TypeError("Count must be an integer")
        
        if not isinstance(item, str):
            raise TypeError("Item name must be a string")
        
        if item not in self.items:
            raise KeyError("Requested item not in the directory")
        
        if count <= 0:
            raise ValueError("Requested count must be a natural number")
        
        if self.items[item] < count:
            raise ValueError("Requested quantity exceeds available stock level")
        
        self.items[item] -= count