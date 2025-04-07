import 'package:dio/dio.dart';
import 'package:tesloapp/config/config.dart';
import 'package:tesloapp/config/logs/logger_impl.dart';

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
        LoggerImpl.log('Solicitud: ${options.method} ${options.path}', level: LogLevel.info);
        return handler.next(options);
      },
      onResponse: (response, handler) 
      {
        LoggerImpl.log('Respuesta: ${response.statusCode}', level: LogLevel.info);
        return handler.next(response);
      },
      onError: (DioException e, handler) 
      {
        LoggerImpl.log('Error: ${e.message}', level: LogLevel.info);
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
        headers: 
        {
          'Content-Type': 'application/json',
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