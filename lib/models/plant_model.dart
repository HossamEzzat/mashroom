// Mushroom model representing information about each mushroom
class Mushroom {
  final String name;               // Common name of the mushroom
  final String image;              // Path to the mushroom image
  final String type;               // Healthy or Poisonous
  final String habitat;            // Natural environment where it grows
  final String edibility;          // Edibility status (e.g., Edible, Deadly)
  final String description;        // General description
  final List<String> symptoms;     // Symptoms if poisonous
  final String sporePrintColor;    // Spore print color (used in identification)

  Mushroom({
    required this.name,
    required this.image,
    required this.type,
    required this.habitat,
    required this.edibility,
    required this.description,
    required this.symptoms,
    required this.sporePrintColor,
  });
}



// Sample data for 15 mushrooms
List<Mushroom> mushrooms = [
  Mushroom(
    name: "Amanita phalloides",
    image: "assets/mushrooms/Amanita phalloides.jpg",
    type: "Poisonous",
    habitat: "Forests, under oak trees",
    edibility: "Deadly poisonous",
    description: "Known as the Death Cap, one of the most poisonous mushrooms worldwide.",
    symptoms: ["Nausea", "Vomiting", "Liver failure", "Death if untreated"],
    sporePrintColor: "White",
  ),
  Mushroom(
    name: "Agaricus bisporus",
    image: "assets/mushrooms/Agaricus bisporus.jpg",
    type: "Healthy",
    habitat: "Grasslands and cultivated fields",
    edibility: "Edible",
    description: "Common edible mushroom found in grocery stores. Also known as the button mushroom.",
    symptoms: [],
    sporePrintColor: "Brown",
  ),
  Mushroom(
    name: "Amanita muscaria",
    image: "assets/mushrooms/Amanita muscaria.jpg",
    type: "Poisonous",
    habitat: "Coniferous and deciduous forests",
    edibility: "Toxic but rarely fatal",
    description: "Bright red with white spots, causes hallucinations and nausea if ingested.",
    symptoms: ["Hallucinations", "Nausea", "Confusion"],
    sporePrintColor: "White",
  ),
  Mushroom(
    name: "Cantharellus cibarius",
    image: "assets/mushrooms/Cantharellus cibarius.jpg",
    type: "Healthy",
    habitat: "Woodlands, especially under hardwood trees",
    edibility: "Edible and delicious",
    description: "Also known as chanterelle. Rich in flavor and popular in cuisine.",
    symptoms: [],
    sporePrintColor: "Yellow",
  ),
  Mushroom(
    name: "Cortinarius rubellus",
    image: "assets/mushrooms/Cortinarius rubellus.jpg",
    type: "Poisonous",
    habitat: "Moist conifer forests",
    edibility: "Deadly poisonous",
    description: "Contains orellanine toxin. Delayed kidney failure can occur.",
    symptoms: ["Flu-like symptoms", "Kidney failure"],
    sporePrintColor: "Rusty brown",
  ),
  Mushroom(
    name: "Morchella esculenta",
    image: "assets/mushrooms/Morchella esculenta.png",
    type: "Healthy",
    habitat: "Forest floors during spring",
    edibility: "Edible (must be cooked)",
    description: "Morel mushroom. Highly sought after for its nutty flavor.",
    symptoms: [],
    sporePrintColor: "Cream",
  ),
  Mushroom(
    name: "Psilocybe cubensis",
    image: "assets/mushrooms/Psilocybe cubensis.jpg",
    type: "Toxic / Hallucinogenic",
    habitat: "Subtropical grasslands",
    edibility: "Psychoactive (illegal in many countries)",
    description: "Known as a magic mushroom. Contains hallucinogenic compounds.",
    symptoms: ["Visual distortions", "Nausea", "Paranoia"],
    sporePrintColor: "Purple-brown",
  ),
  Mushroom(
    name: "Boletus edulis",
    image: "assets/mushrooms/Boletus edulis.jpg",
    type: "Healthy",
    habitat: "Coniferous forests",
    edibility: "Edible and popular",
    description: "Also called porcini mushroom. Widely used in European cuisine.",
    symptoms: [],
    sporePrintColor: "Olive-brown",
  ),
  Mushroom(
    name: "Galerina marginata",
    image: "assets/mushrooms/Galerina marginata.jpg",
    type: "Poisonous",
    habitat: "On dead wood in forests",
    edibility: "Deadly poisonous",
    description: "Small brown mushroom that looks like edible types but is lethal.",
    symptoms: ["Liver damage", "Vomiting", "Coma"],
    sporePrintColor: "Brown",
  ),
  Mushroom(
    name: "Lactarius deliciosus",
    image: "assets/mushrooms/Lactarius deliciosus.jpg",
    type: "Healthy",
    habitat: "Pine forests",
    edibility: "Edible and flavorful",
    description: "Also known as saffron milk cap. Turns orange when cut.",
    symptoms: [],
    sporePrintColor: "Cream to orange",
  ),
  Mushroom(
    name: "Coprinopsis atramentaria",
    image: "assets/mushrooms/Coprinopsis atramentaria.jpg",
    type: "Toxic when mixed with alcohol",
    habitat: "Lawns, meadows",
    edibility: "Edible but toxic with alcohol",
    description: "Also called the ink cap. Safe alone, but toxic with alcohol (causes Antabuse effect).",
    symptoms: ["Nausea", "Vomiting", "Sweating if combined with alcohol"],
    sporePrintColor: "Black",
  ),
  Mushroom(
    name: "Pleurotus ostreatus",
    image: "assets/mushrooms/Pleurotus ostreatus.jpg",
    type: "Healthy",
    habitat: "On decaying wood",
    edibility: "Edible (Oyster mushroom)",
    description: "Common edible mushroom with oyster-like shape and taste.",
    symptoms: [],
    sporePrintColor: "White to lilac-grey",
  ),
  Mushroom(
    name: "Lepiota brunneoincarnata",
    image: "assets/mushrooms/Lepiota brunneoincarnata.jpg",
    type: "Poisonous",
    habitat: "Gardens, grassy areas",
    edibility: "Deadly poisonous",
    description: "Very small but contains deadly toxins. Avoid consumption.",
    symptoms: ["Abdominal pain", "Liver failure", "Death"],
    sporePrintColor: "White",
  ),
  Mushroom(
    name: "Macrolepiota procera",
    image: "assets/mushrooms/Macrolepiota procera.jpg",
    type: "Healthy",
    habitat: "Meadows and woodland edges",
    edibility: "Edible",
    description: "Known as the parasol mushroom. Tall with a scaly cap.",
    symptoms: [],
    sporePrintColor: "White",
  ),
  Mushroom(
    name: "Inocybe erubescens",
    image: "assets/mushrooms/Inocybe erubescens.jpg",
    type: "Poisonous",
    habitat: "Deciduous forests",
    edibility: "Toxic (muscarine poisoning)",
    description: "Causes sweating, salivation, and diarrhea due to muscarine.",
    symptoms: ["Sweating", "Blurred vision", "Difficulty breathing"],
    sporePrintColor: "Brown",
  ),
];

