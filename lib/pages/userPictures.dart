import 'package:cloud_firestore/cloud_firestore.dart';

Map<String, Map<String, dynamic>> userProfilePictures = {
  // PET SITTERS
  'zhanghao@gmail.com': {
    'image': 'images/petSitters/haobin2.png',
    'rating': 4.5,
  },
  'kimmingyu@gmail.com': {
    'image': 'images/petSitters/mingyu.png',
    'rating': 5.0,
  },
  'leejeno@gmail.com': {
    'image': 'images/petSitters/jeno.png',
    'rating': 4.2,
  },
  'alejandrajuico@gmail.com': {
    'image': 'images/petSitters/lejan.png',
    'rating': 5.0,
  },
  'jamiejalandoni@gmail.com': {
    'image': 'images/petSitters/jamie.png',
    'rating': 3.5,
  },
  'yoonjeonghan@gmail.com': {
    'image': 'images/petSitters/jeonghan.png',
    'rating': 4.0,
  },
  'beagamilong@gmail.com': {
    'image': 'images/petSitters/bea.png',
    'rating': 4.3,
  },
  'sunghanbin@gmail.com': {
    'image': 'images/petSitters/haobin1.png',
    'rating': 4.7,
  },

  // PET BREEDERS
  'jacksonwang@gmail.com': {
    'image': 'images/petBreeders/diego.png',
    'rating': 4.9,
  },
  'winter@gmail.com': {
    'image': 'images/petBreeders/mj.png',
    'rating': 4.6,
  },
  'marklee@gmail.com': {
    'image': 'images/petBreeders/mark.png',
    'rating': 4.8,
  },
  'leeseokmin@gmail.com': {
    'image': 'images/petBreeders/samuel.png',
    'rating': 4.3,
  },
  'beyonce@gmail.com': {
    'image': 'images/petBreeders/beyonce.png',
    'rating': 4.2,
  },
  'giselle@gmail.com': {
    'image': 'images/petBreeders/giselle.png',
    'rating': 4.7,
  },
  'zhongchenle@gmail.com': {
    'image': 'images/petBreeders/charlie.png',
    'rating': 4.5,
  },
};

Map<String, Map<String, dynamic>> petProfilePictures = {
  'jjanguri': {
    'name': 'BaoBao',
    'image': 'images/kkuma.png',
  },
  'rumaraket': {
    'name': 'Ziggy Stardust',
    'image': 'images/simba.png'
  }
  // 'Bokkeu': {
  //   'image': 'images/bokkeu.png',
  // },
  // 'Sapphire': {
  //   'image': 'images/sapphire.png',
  // },
  // 'Bam Boo': {
  //   'image': 'images/bamboo.png',
  // },
  // 'Mr. Darcy': {
  //   'image': 'images/darcy.png',
  // },
  // 'Alvin': {
  //   'image': 'images/alvin.png',
  // },
  // 'Alastor': {
  //   'image': 'images/alastor.png',
  // },
  // 'Capt. Sparrow': {
  //   'image': 'images/sparrow.png',
  // },
  // 'Simba': {
  //   'image': 'images/simba.png',
  // },
  // 'Ziggy Stardust': {
  //  'image': 'images/simba.png'
  // }
};

// userPictures.dart

Future<String> getUserImage(String userId) async {
  try {
    // Fetch user data from Firestore using the userId
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // Return the image URL if it exists, or a default image URL if not
    if (userDoc.exists) {
      var userData = userDoc.data() as Map<String, dynamic>;
      return userData['image'] ?? 'images/default.png'; // Fallback to default if no image
    }
    return 'images/default.png'; // Default image if user document doesn't exist
  } catch (e) {
    print("Error fetching user image: $e");
    return 'images/default.png'; // Return default image in case of an error
  }
}

