import 'package:dio/dio.dart';
import 'package:tesloapp/config/config.dart';
import 'package:tesloapp/config/security/http_service.dart';
import 'package:tesloapp/features/auth/domain/domain.dart';
import 'package:tesloapp/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource 
{
  //static final Dio _dio = AppModuleHttp();
  final HttpService httpService = HttpService();

  @override
  Future<User> checkAuthStatus(String token) async 
  {
    try 
    {
      httpService.setAccessToken(token);
      final response = await httpService.dio.get('/auth/check-status');

      final user = UserMapper.userJsonToEntity(response.data);
      return user;


    }on DioException catch (e) 
    {
      if(e.response?.statusCode == 401)
      {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> login(String email, String password) async 
  {
    try 
    {
      final response = await httpService.dio.post('/auth/login', data: {'email': email, 'password': password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
      
    } on DioException catch (e) 
    {
      if(e.response?.statusCode == 401)
      {
        throw CustomError(e.response?.data['message'] ?? 'Credenciales incorrectas');
      }

      if(e.response?.statusCode == 400)
      {
        throw CustomError(e.response?.data['message'] ?? 'Solicitud malformada');
      }

      if(e.type == DioExceptionType.connectionTimeout)
      {
        throw CustomError('Revisar conexión a internet');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }

  }

  @override
  Future<User> register(String email, String password, String fullName) 
  {
    throw UnimplementedError();
  }
  
}
