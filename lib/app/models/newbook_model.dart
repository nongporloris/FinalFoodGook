class NewBookModel {
  String image;

  NewBookModel(this.image);
}

List<NewBookModel> newbooks =
    newBookData.map((item) => NewBookModel(item['image'])).toList();

var newBookData = [
  {"image": "assets/images/1.jpg"},
  {"image": "assets/images/1371591445997.jpeg"},
  {"image": "assets/images/IMG_1892.jpg"},
  {"image": "assets/images/pud-thai-chicken.jpg"},
  {"image": "assets/images/steak.jpg"},
  {"image": "assets/images/tom-yum-kung.jpg"},
];
