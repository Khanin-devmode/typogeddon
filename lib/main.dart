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

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final playerSprite = await loadSprite('player-sprite.png');

    player = Player()
      ..sprite = playerSprite
      ..position = Vector2(size.y, size.x / 2)
      ..width = 100
      ..height = 100
      ..anchor = Anchor.topCenter;
    add(player);

    final line = Line()
      ..position = Vector2(size.x / 2, 100)
      ..width = size.x
      ..height = 1
      ..anchor = Anchor.center;
    add(line);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.move(Vector2(0, -0.5));

    // if (player.position.y == line.position.y) {
    if (player.position.y == 100) {
      remove(player);
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
