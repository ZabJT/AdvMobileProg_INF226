import '../constants.dart';
import 'dart:convert';
import 'package:http/http.dart';

class ArticleService {
  List listData = [];

  Future<List> getAllArticles() async {
    // Return Philippines tourist spots articles
    return [
      {
        "userId": 1,
        "id": 1,
        "title": "Boracay Island: Paradise Reborn After Rehabilitation",
        "body":
            "Boracay Island has emerged stronger than ever after its 2018 rehabilitation, now offering visitors an even more pristine paradise experience. The famous White Beach stretches 4 kilometers with powdery white sand and crystal-clear turquoise waters. Recent improvements include enhanced waste management systems, limited visitor capacity, and stricter environmental regulations. The island now hosts 15,000 visitors daily, down from the previous 25,000, ensuring a more sustainable and enjoyable experience. New attractions include the Boracay Marine Sanctuary, where visitors can snorkel with tropical fish and sea turtles, and the Mount Luho View Deck offering panoramic views of the entire island. The rehabilitation has also led to the discovery of new diving spots and the restoration of coral reefs. Local authorities report that water quality has improved by 85%, making it safe for swimming and water activities year-round.",
        "imageUrl": "assets/images/Boracay.jpg",
      },
      {
        "userId": 2,
        "id": 2,
        "title": "Palawan Underground River: Nature's Hidden Cathedral",
        "body":
            "The Puerto Princesa Underground River, a UNESCO World Heritage Site and one of the New 7 Wonders of Nature, continues to amaze visitors with its spectacular limestone formations and pristine ecosystem. The 8.2-kilometer navigable underground river flows through a cave system featuring stunning stalactites and stalagmites that resemble chandeliers, mushrooms, and even religious figures. Recent developments include improved lighting systems that highlight the cave's natural beauty without disturbing the resident bats and swiftlets. The surrounding Sabang Beach offers pristine white sand and clear waters perfect for swimming and kayaking. The area is also home to diverse wildlife including monitor lizards, macaques, and over 200 species of birds. The local government has implemented strict conservation measures, limiting daily visitors to 1,200 to preserve the delicate ecosystem. New eco-friendly accommodations have been built nearby, offering visitors comfortable stays while maintaining the area's natural charm.",
        "imageUrl": "assets/images/palawan.jpg",
      },
      {
        "userId": 3,
        "id": 3,
        "title":
            "Chocolate Hills of Bohol: Geological Wonder of the Philippines",
        "body":
            "The Chocolate Hills of Bohol, a geological formation of over 1,700 perfectly cone-shaped hills, remain one of the Philippines' most iconic natural wonders. These limestone hills, covered in grass that turns chocolate brown during the dry season, create a surreal landscape that spans 50 square kilometers. Recent developments include the new Chocolate Hills Adventure Park, featuring zip lines that offer breathtaking aerial views of the hills, and the Chocolate Hills Complex with improved viewing decks and educational exhibits. The area has also seen the construction of eco-friendly resorts that blend seamlessly with the natural landscape. Visitors can now enjoy guided tours that explain the geological history of the hills, which are believed to be the result of coral deposits uplifted by tectonic activity millions of years ago. The nearby Loboc River offers floating restaurants where tourists can enjoy local cuisine while cruising through the scenic waterway. Conservation efforts have been strengthened to protect this unique ecosystem from overdevelopment.",
        "imageUrl": "assets/images/chocolate_hills.jpg",
      },
      {
        "userId": 4,
        "id": 4,
        "title": "Vigan Heritage City: Living Museum of Spanish Colonial Era",
        "body":
            "Vigan, a UNESCO World Heritage Site, stands as the best-preserved example of a planned Spanish colonial town in Asia. The city's Calle Crisologo features cobblestone streets lined with centuries-old houses that showcase a unique blend of Spanish, Chinese, and Filipino architecture. Recent restoration projects have revitalized 200 heritage houses, with many now operating as boutique hotels, restaurants, and museums. The city has introduced new cultural experiences including traditional kalesa (horse-drawn carriage) tours, pottery-making workshops at the Pagburnayan, and weaving demonstrations at the Abel Iloco Weaving Center. The Vigan Heritage Village now offers immersive experiences where visitors can dress in period costumes and learn traditional dances. The city's famous empanada and longganisa have gained international recognition, with cooking classes available for tourists. Night tours have been introduced, featuring the beautifully illuminated heritage buildings and traditional music performances. The local government has implemented strict preservation guidelines to maintain the city's authentic character while accommodating modern tourism needs.",
        "imageUrl": "assets/images/vigan.jpg",
      },
      {
        "userId": 5,
        "id": 5,
        "title": "Siargao Island: Surfing Capital and Tropical Paradise",
        "body":
            "Siargao Island, known as the 'Surfing Capital of the Philippines,' has evolved into a comprehensive tropical destination offering more than just world-class waves. Cloud 9, the island's most famous surf break, continues to attract professional surfers from around the world, while new surf spots like Pacifico and Burgos are gaining popularity among intermediate surfers. Beyond surfing, the island now offers diverse activities including island hopping to the stunning Naked, Daku, and Guyam islands, each featuring pristine beaches and crystal-clear waters. The Sugba Lagoon has become a must-visit destination for kayaking, paddleboarding, and cliff jumping. Recent developments include the Siargao Airport expansion, making the island more accessible to international tourists. The island has embraced sustainable tourism with eco-friendly resorts, organic restaurants, and community-based tours that support local livelihoods. The famous Magpupungko Rock Pools offer natural swimming pools during low tide, while the Maasin River provides opportunities for mangrove tours and wildlife spotting. The island's vibrant nightlife scene in General Luna features beachfront bars and restaurants serving fresh seafood and local delicacies.",
        "imageUrl": "assets/images/siargao.jpg",
      },
    ];
  }
}
