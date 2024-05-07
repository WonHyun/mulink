import 'package:audio_service/audio_service.dart';
import 'package:mulink/service/util/generator_util.dart';

const googleDriveApiKey = "AIzaSyDpMsfwW29qGDvbw2kFnBn6vYrkcgcWZI0";

String getGoogleDriveUrl(String fileName) {
  return "https://www.googleapis.com/drive/v3/files/$fileName?alt=media&key=$googleDriveApiKey";
}

final playlistMock = [
  MediaItem(
    id: uuid.v4(),
    title: "Cosmic Stars from asia 'kongfu' house inside special l-u-n-c-h set",
    artist: "Dog[house] of progress system provider get riddim",
    artUri: Uri.file("assets/test/artwork.png"),
    extras: {
      "url": "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
    },
  ),
  MediaItem(
    id: uuid.v4(),
    title: "Breaktime for you",
    artist: "Attrielectrock",
    extras: {
      "url": getGoogleDriveUrl("18G6gbPoBTNKa0PAik5PCfzmv9GiWNfdK"),
    },
  ),
  MediaItem(
    id: uuid.v4(),
    title: "NEXT COLOR PLANET (Still Still Stellar ver.)",
    artist: "Suisei Hoshimachi",
    extras: {
      "url": getGoogleDriveUrl("1jb10kB3a8JAMYHxkTQRNZc4HuUjYRu8C"),
    },
  ),
  MediaItem(
    id: uuid.v4(),
    title: "Somewhere",
    artist: "F",
    extras: {
      "url": getGoogleDriveUrl("17GJeljqc7XcANzwt0o0QUiA8Xh6EidjT"),
    },
  ),
  MediaItem(
    id: uuid.v4(),
    title: "LIES & TIE",
    artist: "Void_Chords",
    extras: {
      "url": getGoogleDriveUrl("1rCWOzQNWAwDUkaUW1RY7qnFWeXuRkQDK"),
    },
  ),
  MediaItem(
    id: uuid.v4(),
    title: "White Cup",
    artist: "Attrielectrock",
    extras: {
      "url": getGoogleDriveUrl("1JrjUP6MchGUEv7eslSDElcti_4X1KQKG"),
    },
  ),
  // Track(
  //   id: uuid.v4(),
  //   title: "Nand got sad people at the zoo",
  //   artist: "Giraffe of the house",
  //   extras: {
  //     "url": "https://s3.amazonaws.com/scifri-segments/scifri201711241.mp3",
  //   },
  //   mediaType: MediaType.url,
  // ),
];
