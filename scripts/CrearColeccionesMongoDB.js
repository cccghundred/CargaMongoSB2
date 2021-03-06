db.createCollection("OfertaPersonalizada")
db.createCollection("OfertaPersonalizadaCuv")
db.createCollection("Estrategia")
db.createCollection("TipoEstrategia")
db.createCollection("ProductoFaltanteZona")
db.createCollection("ProductoComercial")
db.createCollection("Componente")
db.createCollection("Evento")
db.createCollection("EstrategiaDetalle")
db.createCollection("EventoConsultora")
db.createCollection("Nivel")
db.createCollection("Personalizacion")

db.OfertaPersonalizada.createIndex( { AnioCampanaVenta: 1, CUV: 1 }, { name: "CUV" } )
db.OfertaPersonalizada.createIndex( { CodConsultora: 1 }, { name: "CodConsultora" })
db.OfertaPersonalizada.createIndex( { AnioCampanaVenta: 1, TipoPersonalizacion: 1, CUV: 1 }, { name: "Estrategia" } )
db.OfertaPersonalizada.createIndex( { AnioCampanaVenta: 1, TipoPersonalizacion: 1}, { name: "BDI" } )
db.OfertaPersonalizada.createIndex( { AnioCampanaVenta: 1, CodConsultora: 1, TipoPersonalizacion: 1}, {name: "SearchByTipo&CodConsultora"})
db.OfertaPersonalizada.createIndex( { DiaInicio: 1, AnioCampanaVenta: 1, CodConsultora: 1, TipoPersonalizacion: 1}, {name: "SearchODDByCodConsultora"})
db.OfertaPersonalizada.createIndex( { DiaInicio: 1, AnioCampanaVenta: 1, TipoPersonalizacion: 1}, {name: "SearchODD"})
db.OfertaPersonalizada.createIndex( { AnioCampanaVenta: 1, CodConsultora: 1, TipoPersonalizacion: 1, Orden: 1 }, {name: "SearchByCodConsultora"})

db.Estrategia.createIndex( { CodigoCampania: 1, CodigoTipoEstrategia: 1, CUV2: 1 }, { name: "Estrategia" } )

db.ProductoComercial.createIndex({ CodigoCampania: 1}, { name: "CodigoCampania" })

db.ProductoFaltanteZona.createIndex({ CodigoCampania: 1}, { name: "CodigoCampania" })

db.Componente.createIndex({ CampaniaId: 1 }, { name: "CampaniaId" })
db.Componente.createIndex({ Cuv: 1 }, { name: "CUV" })
db.Componente.createIndex({ CuvPadre: 1 }, { name: "CuvPadre" })
db.Componente.createIndex({ EstrategiaId: 1 }, { name: "EstrategiaId" })