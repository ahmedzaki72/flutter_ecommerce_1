import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ecommerce_1/constant.dart';
import 'package:flutter_ecommerce_1/models/product_model.dart';


class Store {


  Future<void> addUser(Product product) {

    CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);

    return products.add({
      kProductName : product.name,
      kProductPrice : product.price,
      kProductDescription : product.description,
      kProductCategory : product.category,
      kProductLocation : product.location,
    });
  }

  // Future<List<Product>> loadingProduct() {
  //   List<Product> productsS = [];
  //   CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);
  //   final doc = products.doc().get();
  //   return productsS;
  // }

 // Future<List<Product>> loadingProduct () async{
 //   CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);
 //   // final products1 = await products.get();
 //   List<Product> products2 = [];
 //   /// i will using snapshot this is using realtime data when update any time.
 //   // final products1 = await products.snapshots();
 //   await for(var products1 in products.snapshots()){
 //     print(products1.docs);
 //
 //     for(var doc in products1.docs) {
 //
 //       final data  = doc.data();
 //       products2.add(Product(
 //         name: data[kProductName],
 //         price: data[kProductPrice],
 //         description: data[kProductDescription],
 //         category: data[kProductCategory],
 //         location: data[kProductLocation],
 //       ));
 //     }
 //
 //   }
 //   return products2;
 // }

   /// using stream
   Stream<QuerySnapshot> loadingProduct () {
    CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);
     return products.snapshots();
   }

   Stream<QuerySnapshot> loadingOrder () {
    CollectionReference orders = FirebaseFirestore.instance.collection(kOrder);
    return orders.snapshots();
   }

   Stream<QuerySnapshot> loadingOrderDetails (documentId) {
    CollectionReference orderDetails = FirebaseFirestore.instance.collection(kOrder).doc(documentId).collection(kOrderDetails);
    return orderDetails.snapshots();
   }
   // deleting product
  deletingProduct (documentId) {
    CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);
    return products.doc(documentId).delete();
  }

  editProduct (data, documentId) {
     CollectionReference products = FirebaseFirestore.instance.collection(kProductCollection);
     products.doc(documentId).update(data);
  }

  storeOrder(data, List<Product> products) {
    var documentRef = FirebaseFirestore.instance.collection(kOrder).doc();
    documentRef.set(data);
    for(var product in products) {
      documentRef.collection(kOrderDetails).doc().set({
        'name' : product.name,
        'price' : product.price,
        'quantity' : product.quantity,
        'location' : product.location,
        'category' : product.category,
      });
    }
  }

}

