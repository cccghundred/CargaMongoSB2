var colls = db.getCollectionNames();
colls.forEach(function(collName) {
    var coll =db.getCollection(collName);
    var indexes = coll.getIndexes().splice(1);
	print("Eliminando colección: " + collName);
    print(coll.drop());
	print("Creando colección: " + collName);
    db.createCollection(collName);
    var ncoll = db.getCollection(collName);
    
    indexes.forEach(function(idx){
		print("Creando índice: " + idx.name);
        ncoll.createIndex(idx.key, { name: idx.name });
    })
})