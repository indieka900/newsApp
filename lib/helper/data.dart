import 'package:news_app/model/category_model.dart';

List<CategoryModel> getCategories() {
  List<CategoryModel> category = <CategoryModel>[];
  CategoryModel categoryModel = CategoryModel();

  //1
  
  categoryModel.categoryName = "Business";
  categoryModel.imageUrl =
      'https://images.unsplash.com/photo-1665686306574-1ace09918530?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80';
  category.add(categoryModel);

  //2
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Entertainment";
  categoryModel.imageUrl =
      'https://media.istockphoto.com/id/1412313417/photo/performance-of-a-popular-group-the-crowd-with-raised-hands-against-the-stage-light.jpg?b=1&s=170667a&w=0&k=20&c=b0daoqXw4xbM-Q64BaEfq5-jBQBooE67HWq8Zftyo3A=';
  category.add(categoryModel);

  //3
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Science";
  categoryModel.imageUrl =
      'https://images.unsplash.com/photo-1532094349884-543bc11b234d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8c2NpZW5jZXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60';
  category.add(categoryModel);

  //4
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Health";
  categoryModel.imageUrl =
      'https://plus.unsplash.com/premium_photo-1675033559419-295e2e4187f3?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjV8fGhlYWx0aHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60';
  category.add(categoryModel);

  //5
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Sports";
  categoryModel.imageUrl =
      'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8c3BvcnRzfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60';
  category.add(categoryModel);

  //6
  categoryModel = CategoryModel();
  categoryModel.categoryName = "Technology";
  categoryModel.imageUrl =
      'https://images.unsplash.com/photo-1488590528505-98d2b5aba04b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dGVjaG5vbG9neXxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60';
  category.add(categoryModel);

  return category;
}
