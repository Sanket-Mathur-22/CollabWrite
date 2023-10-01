import 'package:flutter/material.dart';
import 'package:my_docs/screens/doucment_screen.dart';
import 'package:my_docs/screens/home_screen.dart';
import 'package:my_docs/screens/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (route)=> const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (route)=> const MaterialPage(child: HomePage()),
  '/document/:id':(route)=> MaterialPage(child: DocumentScreen(id: route.pathParameters['id'] ?? '',),)
});
  