enum AppRoute{
  home('home'),
  login('login'),
  signup('signup'),
  wrapper('wrapper');

  const AppRoute(this.name);

  final String name;

  String get path => '/$name';
}