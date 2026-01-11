class PlantOnBording {
  final String title;
  final String description; // Added description
  final String image;

  PlantOnBording({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<PlantOnBording> pOnBording = [
  PlantOnBording(
    image: "assets/plant-shop/mushroomq.png",
    title: "Grow Smart with Mushrooms",
    description:
        "Discover the secret world of fungi and how to cultivate them at home effortlessly.",
  ),
  PlantOnBording(
    image: "assets/plant-shop/mushroomq2.png",
    title: "Nature’s Power in Fungi",
    description:
        "Learn about the medicinal and nutritional benefits hidden within different mushroom species.",
  ),
  PlantOnBording(
    image: "assets/plant-shop/mushroomq4.png",
    title: "Mushrooms: The New Green",
    description:
        "Join the sustainability movement using mushrooms to recycle waste and heal the earth.",
  ),
];
