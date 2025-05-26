import 'package:flutter/material.dart';

class CategoriasSlider extends StatelessWidget {
  final List<String> categorias;
  final ValueChanged<String> onCategoriaSelected;
  final String? categoriaSeleccionada;

  const CategoriasSlider({
    Key? key,
    required this.categorias,
    required this.onCategoriaSelected,
    this.categoriaSeleccionada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: categorias.length,
        separatorBuilder: (_, __) => SizedBox(width: 12),
        itemBuilder: (context, index) {
          final cat = categorias[index];
          final isSelected = cat == categoriaSeleccionada;
          
          return GestureDetector(
            onTap: () => onCategoriaSelected(cat),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
                border: isSelected 
                  ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                  : null,
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 