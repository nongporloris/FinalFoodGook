import 'dart:math';

Random random = Random();
List names = [
  "punymook",
  "chatrin20.zzz",
  "phatto_z",
  "joyfoyy",
  "muji_global",
  "ymmty30",
  "ormpatcha",
  "jype_twicegram",
  "spicedogsss",
  "stkstkstk3105",
  "akari___0302",
];

List foodnames = [
  "Homemade Shoyu Ramen",
  "Air Fryer Cinnamon Rolls",
  "Tres Leches Cake",
  "Chicken Biscuit Potpie",
  "Ham & Spinach Casserole",
  "Black Bean Burritos",
  "Shrimp Pad Thai",
  "Turkey Scallopini",
  "Garlic Chicken with Herbs",
  "Veggie Tacos",
  "Chocolate Pudding",
];

List descriptions = [
  "Hi salmon fans! Here’s another one to tuck in...",
  "What better way to enjoy a weekend night than...",
  "Hola salmon fans! Here’s another one to tuck in...",
  "Sawasdee better way to enjoy a weekend night than...",
  "Hey salmon fans! Here’s another one to tuck in...",
  "Anyeong better way to enjoy a weekend night than...",
  "My better way to enjoy a weekend night than...",
  "Bye salmon fans! Here’s another one to tuck in...",
  "Nani better way to enjoy a weekend night than...",
  "See salmon fans! Here’s another one to tuck in...",
  "Hola better way to enjoy a weekend night than...",
];

List tags = [
  "#salmon  #sauce  #dinner",
  "#strawberry  #dessert ",
  "#appetizer  #bread  #snack",
  "#salad  #lunch",
  "#curry",
  "#healthy",
  "#hommade  #sandwich",
  "#beef",
  "#turkey  #pasta  #meal",
  "#seafood  #shrimp",
  "#cocktail",
];

// List notifs = [
//   "${names[random.nextInt(10)]} and ${random.nextInt(100)} others liked your post",
//   "${names[random.nextInt(10)]} mentioned you in a comment",
//   "${names[random.nextInt(10)]} shared your post",
//   "${names[random.nextInt(10)]} commented on your post",
//   "${names[random.nextInt(10)]} replied to your comment",
//   "${names[random.nextInt(10)]} reacted to your comment",
//   "${names[random.nextInt(10)]} asked you to join a Group️",
//   "${names[random.nextInt(10)]} asked you to like a page",
//   "You have memories with ${names[random.nextInt(10)]}",
//   "${names[random.nextInt(10)]} Tagged you and ${random.nextInt(100)} others in a post",
//   "${names[random.nextInt(10)]} Sent you a friend request",
// ];

// List notifications = List.generate(
//     13,
//     (index) => {
//           "name": names[random.nextInt(10)],
//           "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
//           "time": "${random.nextInt(50)} min ago",
//           // "notif": notifs[random.nextInt(10)]
//         });

List posts = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg", //profile pic
          "time": "${random.nextInt(50)} mins ago",
          "img": "assets/images/em${random.nextInt(10)}.jpeg",
          "foodname": foodnames[random.nextInt(10)],
          "description": descriptions[random.nextInt(10)],
          "tag": tags[random.nextInt(10)],
        });

List types = ["text", "image"];
