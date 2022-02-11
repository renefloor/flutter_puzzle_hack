// ignore_for_file: public_member_api_docs

part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  const ThemeState({required this.theme});

  final IslandTheme theme;

  @override
  List<Object> get props => [theme];
}
