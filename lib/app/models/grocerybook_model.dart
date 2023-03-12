class PopularBookModel {
  String title, author, price, image, description;
  int color;

  PopularBookModel(this.title, this.author, this.price, this.image, this.color,
      this.description);
}

List<PopularBookModel> populars = popularBookData
    .map((item) => PopularBookModel(item['title'], item['author'],
        item['price'], item['image'], item['color'], item['description']))
    .toList();

var popularBookData = [
  {
    "title": "Greek Farro Salad",
    "author": "",
    "price": "12/15 ingredients",
    "image": "assets/images/Greek Farro Salad.jpeg",
    "color": 0xFFFFD3B6,
    "description":
        "“Holding brain science in one hand and rich emotional presence in the other, this book feels timely and necessary.”—Shauna Niequist, New York Times bestselling author of Present Over Perfect\n\nWhy is there such a gap between what you want to do and what you actually do? The host of Ask Science Mike explains why our desires and our real lives are so wildly different—and what you can do to close the gap.\n\nFor thousands of years, scientists, philosophers, and self-help gurus have wrestled with one of the basic conundrums of human life: Why do we do the things we do? Or, rather, why do we so often not do the things we want to do? As a podcast host whose voice goes out to millions each month, Mike McHargue gets countless emails from people seeking to understand their own misbehavior—why we binge on Netflix when we know taking a walk outside would be better for us, or why we argue politics on Facebook when our real friends live just down the street. Everyone wants to be a good person, but few of us, twenty years into the new millennium, have any idea how to do that.\n\nIn You’re a Miracle (and a Pain in the Ass), McHargue addresses these issues. We like to think we’re in control of our thoughts and decisions, he writes, but science has shown that a host of competing impulses, emotions, and environmental factors are at play in every action we undertake. Touching on his podcast listeners’ most pressing questions, from relationships and ethics to stress and mental health, and sharing some of the biggest triumphs and hardships from his own life, McHargue shows us how some of our qualities that seem most frustrating—including “negative” emotions like sadness, anger, and anxiety—are actually key to helping humans survive and thrive. In doing so, he invites us on a path of self-understanding and, ultimately, self-acceptance.\n\nYou’re a Miracle (and a Pain in the Ass) is a guided tour through the mystery of human consciousness, showing readers how to live more at peace with themselves in a complex world."
  },
  {
    "title": "Pumpkin Soup",
    "author": "Kerry Johnston",
    "price": "5/8 ingredients",
    "image": "assets/images/Pumpkin Soup.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
  {
    "title": "Thai beef salad",
    "author": "Mike Brow",
    "price": "8/10 ingredients",
    "image": "assets/images/Thai beef salad.jpeg",
    "color": 0xFFF7EA4A,
    "description":
        "This aromatic Asian salad combines lemony-flavoured coriander leaves with cool cucumber, refreshing mint and rare beef."
  },
  {
    "title": "Brown Butter Cookies",
    "author": "Kerry Johnston",
    "price": "10/11 ingredients",
    "image": "assets/images/Brown Butter Cookies.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
  {
    "title": "Strawberry Jam Crostata",
    "author": "Kerry Johnston",
    "price": "3/3 ingredients",
    "image": "assets/images/Strawberry Jam Crostata.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
  {
    "title": "Salmon Sashimi Rice Bowl",
    "author": "Kerry Johnston",
    "price": "3/3 ingredients",
    "image": "assets/images/Salmon Sashimi Rice Bowl.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
  {
    "title": "Matcha Panna Cotta",
    "author": "Kerry Johnston",
    "price": "6/10 ingredients",
    "image": "assets/images/Matcha Panna Cotta.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
  {
    "title": "Gyoza",
    "author": "Kerry Johnston",
    "price": "3/3 ingredients",
    "image": "assets/images/Gyoza.jpeg",
    "color": 0xFF2B325C,
    "description":
        "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text.\n\nAll the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc."
  },
];
