enum AppRoute{
  login('login'),
  signup('signup'),
  home('home');

  const AppRoute(this.name);

  final String name;

  String get path => '/$name';
}