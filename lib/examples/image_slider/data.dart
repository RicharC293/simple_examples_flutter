class Data {
  const Data({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
  });

  final int id;
  final String image;
  final String title;
  final String description;

  Data copyWith({
    int? id,
    String? image,
    String? title,
    String? description,
  }) {
    return Data(
      id: id ?? this.id,
      image: image ?? this.image,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

const List<Data> data = [
  Data(
    id: 1,
    title: "The Godfather",
    description:
        "La familia Corleone es una de las más poderosas de Nueva York. Su patriarca, Vito Corleone, es respetado y temido en igual medida. Cuando intentan matarlo, su hijo Michael se involucra en el mundo del crimen organizado para vengar a su padre.",
    image:
        "https://m.media-amazon.com/images/M/MV5BMTQyMDc0ODY1OV5BMl5BanBnXkFtZTgwMDI4NjIwMjE@._V1_.jpg",
  ),
  Data(
    id: 2,
    title: "Forrest Gump",
    description:
        "Forrest Gump es un hombre de mente simple que logra grandes cosas en su vida. Desde jugar al fútbol en la universidad hasta luchar en Vietnam y convertirse en multimillonario, su historia es una lección de vida.",
    image:
        "https://resuelvetudeuda.com/wp-content/uploads/2017/10/forrestGump_ResuelvetuDeuda.png",
  ),
  Data(
    id: 3,
    title: "The Shawshank Redemption",
    description:
        "Basada en la novela de Stephen King, esta película cuenta la historia de Andy Dufresne, un banquero condenado injustamente por el asesinato de su esposa. En la cárcel, encuentra amistad y esperanza en un compañero llamado Red.",
    image:
        "https://images-na.ssl-images-amazon.com/images/S/pv-target-images/aa17005fd6e7eb3e15e32b9f9252e0aea07b50c7bd0bfe686ac45498fc6f809b._RI_V_TTW_.jpg",
  ),
  Data(
    id: 4,
    title: "The Dark Knight",
    description:
        "Batman se enfrenta a su mayor desafío cuando el Guasón aparece en Gotham City. El villano tiene un plan para destruir la ciudad y el Caballero Oscuro debe detenerlo antes de que sea demasiado tarde.",
    image:
        "https://larepublica.cronosmedia.glr.pe/migration/images/TLBIGOIGTFGCBIU4TECGW7KOLA.jpg",
  ),
  Data(
    id: 5,
    title: "The Lord of the Rings: The Return of the King",
    description:
        "La trilogía de El Señor de los Anillos llega a su fin con esta película. Frodo y Sam se acercan al Monte del Destino, mientras que Aragorn y sus aliados se preparan para la batalla final contra Sauron.",
    image:
        "https://media.contentapi.ea.com/content/dam/gin/images/2017/01/lotr-the-return-of-the-king-keyart-min.jpg.adapt.crop16x9.575p.jpg",
  ),
  Data(
    id: 6,
    title: "Pulp Fiction",
    description:
        "Esta película de Quentin Tarantino cuenta tres historias diferentes que se entrelazan entre sí. Un boxeador, un gángster y dos asesinos a sueldo se ven envueltos en una serie de eventos que cambiarán sus vidas para siempre.",
    image:
        "https://occ-0-3933-55.1.nflxso.net/dnm/api/v6/E8vDc_W8CLv7-yMQu8KMEC7Rrr8/AAAABSGtv55T_iUdTa9fXCVk1jXTwYT3kd0SsILKwz_Yb_LI17SXTaRH2vyTXM0A9Syjlex2e5WphqXRyIHMRI5mBuxVAxyA28RQ8uTs.jpg?r=3b9",
  ),
  Data(
    id: 7,
    title: "The Dark Knight",
    description:
        "En esta secuela de Batman Begins, el Caballero Oscuro se enfrenta a su enemigo más peligroso, el Joker, quien quiere sumir a Gotham City en el caos. Con la ayuda del teniente Gordon y el fiscal Harvey Dent, Batman debe detener los planes del Joker antes de que sea demasiado tarde.",
    image:
        "https://larepublica.cronosmedia.glr.pe/migration/images/TLBIGOIGTFGCBIU4TECGW7KOLA.jpg",
  ),
  Data(
    id: 8,
    title: "Interstellar",
    description:
        "En un futuro cercano, la Tierra se está muriendo. Un grupo de astronautas es enviado en una misión para encontrar un nuevo hogar para la humanidad en otro sistema estelar. Pero el viaje no será fácil y tendrán que enfrentar peligros desconocidos en el espacio.",
    image:
        "https://www.semana.com/resizer/sO_n14FLrcruJHJhgHXc6FF2hiY=/1920x1080/smart/filters:format(jpg):quality(80)/cloudfront-us-east-1.images.arcpublishing.com/semana/D6COKJW4HJCKVFR6UJ6M7VOZNE.jpg",
  ),
  Data(
    id: 9,
    title: "Inception",
    description:
        "Dom Cobb es un ladrón especializado en robar información valiosa del subconsciente de las personas a través de sus sueños. Pero cuando se le ofrece la oportunidad de implantar una idea en la mente de alguien, debe reunir a un equipo de expertos para realizar el trabajo más peligroso de su carrera.",
    image:
        "https://www.joblo.com/wp-content/uploads/2010/05/inception-poster-quad-1.jpg",
  ),
  Data(
    id: 10,
    title: "The Matrix",
    description:
        "Thomas Anderson es un programador que vive una vida normal, pero pronto descubre que su realidad es una simulación creada por máquinas para esclavizar a la humanidad. Con la ayuda de otros rebeldes, Thomas lucha contra las máquinas en un mundo virtual para liberar a la humanidad del control de las máquinas.",
    image: "https://i.blogs.es/8b8798/06-06-matrix/1366_2000.jpg",
  ),
];
