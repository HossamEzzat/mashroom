class PlantOnBording {
  String title;
  String image;
  PlantOnBording({
    required this.image,
    required this.title,
  });
}

List<PlantOnBording> pOnBording = [
  PlantOnBording(
    image: "assets/plant-shop/mushroomq.png",
    title: "Grow Smart with Mushrooms",
  ),
  PlantOnBording(
    image: "assets/plant-shop/mushroomq2.png",
    title: "Nature’s Power in Fungi",
  ),
  PlantOnBording(
    image: "assets/plant-shop/mushroomq4.png",
    title: "Mushrooms: The New Green",
  )
];