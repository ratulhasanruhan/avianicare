import 'package:flutter/material.dart';

const String regularExpressionEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

const sortByList = [
  "Newest",
  "Price Low To High",
  "Price High To Low",
  "Top Rated",
];


const LinearGradient buttonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFF097F69),
    Color(0xFF7EB86A),
  ],
);