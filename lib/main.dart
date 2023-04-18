import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;
  late Line line;
  late Word word1;

  final random = Random();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final playerSprite = await loadSprite('player-sprite.png');

    print(size);

    player = Player()
      ..sprite = playerSprite
      ..position = Vector2(size.x / 2, size.y)
      ..width = 100
      ..height = 100
      ..anchor = Anchor.topCenter;
    add(player);

    line = Line()
      ..position = Vector2(size.x / 2, 100)
      ..width = size.x
      ..height = 1
      ..anchor = Anchor.center;
    add(line);

    word1 = Word()
      ..text = 'Lorem'
      ..position = Vector2(size.x * random.nextDouble(), size.y);
    add(word1);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);

    player.move(Vector2(0, -2));
    word1.move(Vector2(0, -2));
    // print('${player.position.y} : ${line.position.y}');
    if (player.position.y == line.position.y) {
      remove(player);
    }
    if (word1.position.y == line.position.y) {
      remove(word1);
    }

    if (player.isRemoved) {
      player.position.x = size.x * random.nextDouble();
      player.position.y = size.y;
      add(player);
    }

    if (word1.isRemoved) {
      word1.position.x = size.x * random.nextDouble();
      word1.position.y = size.y;
      add(word1);
    }
  }
}

class Line extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }

  // void move(Vector2 delta) {
  //   position.add(delta);
  // }
}

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  void move(Vector2 delta) {
    position.add(delta);
  }
}

class Word extends TextComponent {
  void move(Vector2 delta) {
    position.add(delta);
  }
}
