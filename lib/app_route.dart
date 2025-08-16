enum AppRoute{
  login('login'),
  home('home');

  const AppRoute(this.name);

  final String name;

  String get path => '/$name';
}