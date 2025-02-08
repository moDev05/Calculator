import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String? text;
  final Color color;
  final double? width;

  const CalcButton({
    super.key, // Le paramètre key est passé directement à la classe parente
    required this.onPressed,
    this.icon,
    this.text,
    this.width,
    this.color = const Color.fromARGB(255, 50, 50, 50),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 80, // Largeur du bouton
      height: 80, // Hauteur du bouton
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 5.0,
        fillColor: color,
        shape: width != null ?
          RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))) :
          CircleBorder(),
        child: FittedBox(
          child: icon != null
              ? Icon(icon, color: Colors.white, size: 40)
              : Text(
                  text ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}
