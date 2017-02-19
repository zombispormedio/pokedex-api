# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PokedexApi.Repo.insert!(%PokedexApi.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PokedexApi.Repo

alias PokedexApi.User
alias PokedexApi.PokeApi


alias PokedexApi.Pokemon

Repo.insert(%Pokemon{ 
    name: "Cyndaquil",
    description: "Cyndaquil es un Pokémon tímido y pequeño; que recuerda a un equidna. Su piel es azulada en la parte superior de su cuerpo, pero un color crema en la parte inferior.
Una de sus características más notorias es que puede encender su llama a voluntad, a diferencia de otros Pokémon de tipo fuego con llamas en su cuerpo como Charmander (con sus respectivas evoluciones) y Magmar. Las llamas de este Pokémon salen de cuatro pequeños orificios en su espalda, que se encienden cuando está a punto de pelear. Al igual que muchos Pokémon de tipo fuego el tamaño de su llama depende del estado en que este se encuentre: si está contento, eufórico o furioso su llama será más grande, y si está enfermo o deprimido el tamaño del fuego sobre su lomo se verá muy reducido. Cyndaquil utiliza el fuego de su lomo para defenderse en caso de que algún depredador se abalance sobre él.",
evolution: "Quilava",
sprite: PokeApi.sprite("Cyndaquil"),
type1_id: 4
})

Repo.insert(%Pokemon{ 
    name: "Quilava",
    description: "Se asemeja a algún tipo de mustélido, posiblemente al Armiño, debido a su falta de cola y el que el pelaje superior de su cuerpo es más oscuro que el inferior. También al puercoespín crestado, que posee un pelaje largo en la cabeza, y púas especialmente en la parte final del dorso y la cola, en los lugares donde Quilava produce llamas. Al igual que su preevolución y evolución, posee unos orificios que le permite encender sus llamas a voluntad, solo que cambiaron su posición: ahora los tiene sobre la cabeza, que cuando se prenden da un aspecto de cresta, y la base de su torso. Es más rápido que su preevolución, ahora tiene los ojos abiertos y son de color rojo.",
evolution: "Typhlosion",
sprite: PokeApi.sprite("Quilava"),
type1_id: 4
})

Repo.insert(%Pokemon{ 
    name: "Typhlosion",
    description: "Se asemeja a algún tipo de mustélido. Principalmente se parece a una comadreja o a un turón, aunque también se puede comparar con un glotón o con un tejón, especialmente al tejón de la miel o tejón melero.
A diferencia de sus preevoluciones, tiene los orificios de donde salen sus llamas en la espalda, exactamente entre los hombros. Es mucho más rápido y grande que sus formas pasadas, casi tan alto como un hombre adulto, y también puede mantenerse sobre sus patas traseras, lo cual le permite realizar ataques con las extremidades superiores. Tiene la capacidad de causar explosiones en su pelaje y crea llamaradas explosivas con ondas expansivas que lo abrasan todo, hasta las cenizas.",
sprite: PokeApi.sprite("Typhlosion"),
type1_id: 4
})

Repo.insert(%Pokemon{ 
    name: "Misdreavus",
    description: "Este Pokémon está basado en una Banshee, de ahí su aspecto femenino y su asociación a los gritos. A este Pokémon fantasmagórico le gusta asustar a los niños que van solos por la noche, aunque sólo lo hace por diversión propia, normalmente usa como arma sus gritos, que a su vez es lo que más los caracteriza. Las perlas de su cuello son su fuente de poder, si alguna se cayera, la fuerza de Misdreavus se debilitaría, por eso cuando le atacan las cuida con gran esmero para que no las dañen. Misdreavus es un Pokémon muy solitario, por lo que normalmente se le puede encontrar en casas abandonadas y cementerios. Para agarrar objetos usa dos mechones de su cabello como manos.",
evolution: "Mismagius",
sprite: PokeApi.sprite("Misdreavus"),
type1_id: 5
})

Repo.insert(%Pokemon{ 
    name: "Mismagius",
    description: "Mismagius es un Pokémon muy solitario, y mucha gente no desea que se le aparezca, pues se dice que trae malos augurios. Sin embargo, si un entrenador lo cuida y no le teme, será un rival difícil de vencer. También hay que destacar que se le teme porque es un Pokémon al que le gusta hacer travesuras, sobretodo cuando ve que una persona tiene miedo; por ello se podría decir que tiene la habilidad de detectar si una persona está asustada o no.",
sprite: PokeApi.sprite("Mismagius"),
type1_id: 5
})

Repo.insert(%Pokemon{ 
    name: "Petilil",
    description: "A Petilil le agradan los suelos ricos en nutrientes. Vive y crece en los cultivos que se plantan en esta clase de terrenos. Es una dichosa señal que en los campos habiten Petilil, ya que esto quiere que su producción será excelente.",
evolution: "Lilligant",
sprite: PokeApi.sprite("Petilil"),
type1_id: 14
})

Repo.insert(%Pokemon{ 
    name: "Lilligant",
    description: "El aroma de las flores en su cabeza tiene un efecto relajante, pero si alguien las recorta al instante se marchitan. Tiene apariencia de reina, y debido a su belleza y elegancia es un Pokémon muy buscado tanto para combatir como para los concursos.",
sprite: PokeApi.sprite("Lilligant"),
type1_id: 14
})

Repo.insert(%Pokemon{ 
    name: "Tympole",
    description: "Tympole está basado en un renacuajo: su cabeza es redonda, tiene ojos ovalados y sus cejas tienen forma de renacuajo, sus oídos parecen tapones, su cola es muy parecida a la de Poliwag y le gusta vivir en aguas lodosas. Curiosamente cuando se encuentran al aire libre cantan y saltan como en coreografía, tal vez porque saben movimientos como canon, eco voz y vozarrón.",
evolution: "Palpitoad",
sprite: PokeApi.sprite("Palpitoad"),
type1_id: 18
})

Repo.insert(%Pokemon{ 
    name: "Palpitoad",
    description: "Está basado en un renacuajo en plena metamorfosis. Las protuberancias de su cabeza pueden vibrar y producir terremotos y olas. Tienen lenguas largas y viscosas para atrapar a sus presas. Puede vivir tanto en el agua como en la tierra. Comparte las mismas características de metamorfosis que Poliwag y sus evoluciones, igual que comparte sus mismos ataques y características como la de su tipo.",
evolution: "Seismitoad",
sprite: PokeApi.sprite("Palpitoad"),
type1_id: 18,
type2_id: 6
})

Repo.insert(%Pokemon{ 
    name: "Seismitoad",
    description: "Está basado en un sapo. Se asemeja bastante a los sapos marinos (bufonidos) pero presenta el cuerpo cubierto de bultos grandes y redondos por donde segrega el veneno como los sapos del género bombina bombina (sapos de vientre de fuego). Además, al igual que estos sapos, se comunica croando mediante vibraciones del cuerpo y presenta un aspecto rechoncho. La forma variocolor de este Pokémon presenta el color de dichos sapos.",
sprite: PokeApi.sprite("Seismitoad"),
type1_id: 18,
type2_id: 6
})

Repo.insert(%Pokemon{ 
    name: "Solgaleo",
    description: "Desde tiempos inmemoriales, a Solgaleo se le ha considerado heraldo del Sol. De hecho, se le suele describir como “la criatura que se nutre del Sol”. Su cuerpo contiene una cantidad ingente de energía y brilla con luz propia cuando está activo. Su melena ondea al viento, lo que le confiere un considerable parecido con el sol.",
type1_id: 9,
type2_id: 8
})

Repo.insert(%Pokemon{ 
    name: "Buzzwole",
    description: "Buzzwole o como los científicos lo llaman UE-02: Expansión, es un ultraente que se asemeja a un mosquito antropomórfico de color rojo. Presenta un cuerpo muy fornido, con venas blancas que corren a través de su cuerpo. Su cabeza es pequeña y plana y tiene dos ojos negros. Posee una probóscide extremadamente alargada, que se dice que está hecho de un material indestructible y que es más duro que los diamantes, se cree que puede utilizarla de forma ofensiva. Buzzwole presenta antenas con púas negras y de una coloración rojiza, se desplaza mediante cuatro apéndices articulados.",
type1_id: 1,
type2_id: 12
})

Repo.insert(%Pokemon{ 
    name: "Magearna",
    description: "Mientras que su aspecto se basa en un autómata karakuri típico de Japón, la naturaleza de Magearna nace de la alquimia, una mezcla entre diversas artes científicas, metalúrgicas y esotéricas en las que creían algunos sabios de la antigüedad. Con la cual se podría, entre otras cosas, unir la maquinaría artificial y la vida natural en un solo ser gracias al hombre.",
type1_id: 9,
type2_id: 3
})

Repo.insert(%Pokemon{ 
    name: "Celebi",
    description: "Celebi es un pequeño Pokémon singular que habita en bosques y encinares. Está basado en los espíritus míticos del Japón, llamados Kodamas (habitantes de los bosques espesos). Su forma corporal es muy similar a un hada. Tiene una cabeza muy peculiar, la cual recuerda a una flor de azucena sin abrir, tanto en tonalidades como en forma. Posee unas antenas muy sensibles al movimiento del aire, con forma puntiaguda y con una tonalidad azul en su extremo. Sus ojos son grandes, de color azul y rodeados de una gruesa linea negra. Su cuerpo es de dos tonalidades de color verde, sus pies son ovalados y grandes, y sus manos terminan en 3 puntas. Todo su cuerpo recuerda a una planta de azucena, especie en la que está basado.",
type1_id: 8,
type2_id: 14,
sprite: PokeApi.sprite("Celebi")
})


Repo.insert(%User{token: Ecto.UUID.generate(), last_access: Ecto.DateTime.utc()})




