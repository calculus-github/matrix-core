import pyautogui
import random
import time

pyautogui.FAILSAFE = False

def move_mouse():
  # déplacer la souris de manière aléatoire dans une zone définie
  x_coord = random.randint(20, 2540)
  y_coord = random.randint(20, 1420)
  pyautogui.moveTo(x=x_coord, y=y_coord, duration=0.5)

def click_mouse():
  # cliquer aléatoirement avec le bouton gauche ou droit de la souris
  button = random.choice(['left', 'right'])
  pyautogui.click(button=button)

def scroll_mouse():
  # faire défiler la souris vers le haut ou vers le bas de manière aléatoire
  clicks = random.randint(10, 50)
  if random.choice([True, False]):
    clicks = -clicks  # faire défiler la souris vers le haut
  pyautogui.scroll(clicks=clicks)


while True:
  # exécuter aléatoirement une action de souris
  action = random.choice([move_mouse, click_mouse, scroll_mouse])
  action()
  # ajouter un délai aléatoire entre chaque action
  time.sleep(random.uniform(0.2, 0.3))
