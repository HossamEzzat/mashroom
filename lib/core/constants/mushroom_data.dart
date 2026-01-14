import '../../models/plant_model.dart';

final List<Mushroom> mushroomList = [
  Mushroom(
    name: 'Amanita muscaria',
    image: 'assets/mushrooms/Amanitamuscaria.jpg',
    type: 'Poisonous',
    habitat: 'Forests, near birch and pine trees',
    edibility: 'Toxic',
    description:
        'Iconic red cap with white spots. Highly toxic and hallucinogenic.',
    symptoms: ['Nausea', 'Hallucinations', 'Confusion'],
    sporePrintColor: 'White',
  ),
  Mushroom(
    name: 'Boletus edulis',
    image: 'assets/mushrooms/Boletus.jpg',
    type: 'Edible',
    habitat: 'Deciduous and coniferous forests',
    edibility: 'Edible',
    description: 'Prized edible mushroom, known as porcini or king bolete.',
    symptoms: [],
    sporePrintColor: 'Olive-brown',
  ),
  Mushroom(
    name: 'Chanterelle',
    image: 'assets/mushrooms/Cantharellus.jpg',
    type: 'Edible',
    habitat: 'Hardwood and coniferous forests',
    edibility: 'Edible',
    description: 'Golden-yellow funnel-shaped mushroom with a fruity aroma.',
    symptoms: [],
    sporePrintColor: 'Pale yellow',
  ),
  Mushroom(
    name: 'Death Cap',
    image: 'assets/mushrooms/Amanita phalloides.jpg',
    type: 'Poisonous',
    habitat: 'Near oak and chestnut trees',
    edibility: 'Deadly',
    description:
        'One of the most poisonous mushrooms. Responsible for most fatal poisonings.',
    symptoms: ['Severe abdominal pain', 'Vomiting', 'Liver failure'],
    sporePrintColor: 'White',
  ),
  Mushroom(
    name: 'Agaricus bisporus',
    image: 'assets/mushrooms/Agaricusbisporus.jpg',
    type: 'Edible',
    habitat: 'Grasslands, fields, and meadows',
    edibility: 'Edible',
    description:
        'The most commonly eaten mushroom worldwide, ranging from white button to portobello.',
    symptoms: [],
    sporePrintColor: 'Dark brown',
  ),
  Mushroom(
    name: 'Morchella esculenta',
    image: 'assets/mushrooms/Morchella.png',
    type: 'Edible',
    habitat: 'Woodlands, often near ash, elm, and apple trees',
    edibility: 'Edible',
    description:
        'Distinctive honeycomb appearance. Highly prized culinary mushroom. Toxic if raw.',
    symptoms: ['Nausea if raw', 'Stomach pain if raw'],
    sporePrintColor: 'Creamy white',
  ),
  Mushroom(
    name: 'Pleurotus ostreatus',
    image: 'assets/mushrooms/Pleurotus.jpg',
    type: 'Edible',
    habitat: 'Deciduous trees, especially beech and oak',
    edibility: 'Edible',
    description:
        'Oyster-shaped cap, widely cultivated and versatile in cooking.',
    symptoms: [],
    sporePrintColor: 'White to lilac-gray',
  ),
  Mushroom(
    name: 'Galerina marginata',
    image: 'assets/mushrooms/Galerina.jpg',
    type: 'Poisonous',
    habitat: 'Rotting wood of coniferous trees',
    edibility: 'Deadly',
    description:
        'Small brown mushroom. Contains fatal amatoxins similar to the Death Cap.',
    symptoms: ['Severe abdominal pain', 'Liver damage', 'Vomiting'],
    sporePrintColor: 'Rusty brown',
  ),
  Mushroom(
    name: 'Coprinopsis atramentaria',
    image: 'assets/mushrooms/Coprinopsis.jpg',
    type: 'Poisonous',
    habitat: 'Gardens, meadows, near buried wood',
    edibility: 'Toxic with Alcohol',
    description:
        'Edible but toxic when consumed with alcohol (Ink Cap Syndrome).',
    symptoms: ['Flushing', 'Nausea', 'Palpitations'],
    sporePrintColor: 'Black',
  ),
  Mushroom(
    name: 'Psilocybe cubensis',
    image: 'assets/mushrooms/Psilocybe.jpg',
    type: 'Poisonous',
    habitat: 'Rich soil, often on dung',
    edibility: 'Psychoactive',
    description:
        'Well-known psychoactive mushroom. Causes intense hallucinations.',
    symptoms: ['Hallucinations', 'Altered perception', 'Anxiety'],
    sporePrintColor: 'Purple-brown',
  ),
];
