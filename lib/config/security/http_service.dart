import 'package:dio/dio.dart';
import 'package:tesloapp/config/config.dart';

class HttpService 
{
  // Instancia privada de Dio
  static Dio? _dio;
  static final HttpService _instance = HttpService._internal();

  // Constructor privado
  HttpService._internal()
  {
    // Configurando interceptores
    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) 
      {
        print('Solicitud: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) 
      {
        print('Respuesta: ${response.statusCode}');
        return handler.next(response);
      },
      onError: (DioException e, handler) 
      {
        print('Error: ${e.message}');
        return handler.next(e);
      },
    ));
  }

  // Factoria para acceder a la instancia de HttpService
  factory HttpService() 
  {
    _dio ??= Dio(
      BaseOptions(
        baseUrl: Environment.apiUrl,  // Reemplaza con tu URL base
        connectTimeout: Duration(seconds: 5), // 5 segundos
        receiveTimeout: Duration(seconds: 3), // 3 segundos
        validateStatus: (status) 
        {
          // Devuelve `true` si el estado es exitoso o si es el código 400
          return (status! >= 200 && status < 300) || status == 400;
        },
      ),
    );
    return _instance;
  }

  // Método para obtener la instancia de Dio
  Dio get dio => _dio!;

  // Método para establecer el token de acceso (si es necesario)
  void setAccessToken(String token) 
  {
    _dio?.options.headers['Authorization'] = 'Bearer $token';
  }
}