import '../models/course.dart';
import 'demo_data.dart';

abstract class CourseRepository {
  Future<List<Course>> obtenerCursos();
}

class DemoCourseRepository implements CourseRepository {
  @override
  Future<List<Course>> obtenerCursos() async {
    await Future.delayed(const Duration(seconds: 2));
    return cursosDemo;
  }
}
