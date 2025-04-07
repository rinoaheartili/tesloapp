import 'package:dio/dio.dart';
import 'package:tesloapp/config/config.dart';
import 'package:tesloapp/features/products/domain/domain.dart';

import '../mappers/product_mapper.dart';
import '../errors/product_errors.dart';

class ProductsDatasourceImpl extends ProductsDatasource 
{
  final HttpService httpService = HttpService();
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken,
  });

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async
  {
    httpService.setAccessToken(accessToken);
    try 
    {  
      final String? productId = productLike['id'];
      final String method = (productId == null) ? 'POST' : 'PATCH';
      final String url = (productId == null) ? '/products' : '/products/$productId';

      productLike.remove('id');

      final response = await httpService.dio.request(url, data: productLike, options: Options(method: method));

      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    } catch (e) 
    {
      throw Exception();
    }
  }

  @override
  Future<Product> getProductById(String id) async
  {
     try {
      
      final response = await httpService.dio.get('/products/$id');
      final product = ProductMapper.jsonToEntity(response.data);
      return product;

    } on DioException catch (e) 
    {
      if ( e.response!.statusCode == 404 ) throw ProductNotFound();
      throw Exception();
    }catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async 
  {
    httpService.setAccessToken(accessToken);
    final response = await httpService.dio.get<List>('/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? [] ) {
      products.add(ProductMapper.jsonToEntity(product));
    }

    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) 
  {
    throw UnimplementedError();
  }

}