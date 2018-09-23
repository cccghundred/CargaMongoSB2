var updateOperations = [];
db.ProductoFaltanteZona.find({Zonas : {"$type": 2}}).forEach(function(doc){ 
	if(doc.Zonas.trim().length > 0){
		var zonasArray = doc.Zonas.split('|');
		updateOperations.push({
			updateOne: {
				filter: { "_id": doc._id },
				update: { "$set": { Zonas: zonasArray } }
			}
		});
	}		
	if(updateOperations.length >= 1000){
		db.ProductoFaltanteZona.bulkWrite(updateOperations);
		updateOperations = [];
	}
});

if(updateOperations.length > 0){
	db.ProductoFaltanteZona.bulkWrite(updateOperations);
	updateOperations = [];
}