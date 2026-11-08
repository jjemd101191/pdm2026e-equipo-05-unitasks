/// Preferencias de la app que no pertenecen a cursos ni tareas.
///
/// Por ahora solo guarda si el plan Premium (demostración) está activo.
abstract class SettingsRepository {
  Future<bool> esPremium();

  Future<void> activarPremium();

  Future<void> desactivarPremium();
}
