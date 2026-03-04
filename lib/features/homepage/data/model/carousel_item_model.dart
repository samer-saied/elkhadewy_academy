/// Base model for carousel-like items.
abstract class CarouselModel {
  final String id;
  final String urlImage;

  const CarouselModel({required this.id, required this.urlImage});
}

class CarouselItemModel extends CarouselModel {
  final String description;
  final String title;
  final int priority;

  CarouselItemModel({
    required super.id,
    required super.urlImage,
    required this.priority,
    required this.title,
    required this.description,
  });

  factory CarouselItemModel.fromFirestore(dynamic snapshot) {
    // Support DocumentSnapshot-like objects and gracefully handle missing
    // fields by providing sensible defaults.
    final rawData = ((snapshot as dynamic).data?.call() ?? (snapshot as dynamic)) as Map<String, dynamic>?;
    final data = rawData ?? <String, dynamic>{};

    final id = (snapshot as dynamic).id?.toString() ?? '';
    final title = data['title']?.toString() ?? '';
    final description = data['description']?.toString() ?? '';
    final urlImage = data['urlImage']?.toString() ?? '';
    final priorityVal = data['priority'];
    final priority = priorityVal is int
        ? priorityVal
        : int.tryParse(priorityVal?.toString() ?? '') ?? 0;

    return CarouselItemModel(
      id: id,
      title: title,
      description: description,
      urlImage: urlImage,
      priority: priority,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'urlImage': urlImage,
      'priority': priority,
    };
  }

  CarouselItemModel copyWith({
    String? id,
    int? priority,
    String? title,
    String? description,
    String? urlImage,
  }) {
    return CarouselItemModel(
      id: id ?? this.id,
      priority: priority ?? this.priority,
      title: title ?? this.title,
      description: description ?? this.description,
      urlImage: urlImage ?? this.urlImage,
    );
  }
}
