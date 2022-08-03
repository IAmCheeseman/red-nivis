file_contents = """
[gd_resource type="AtlasTexture" load_steps=2 format=2]

[ext_resource path="res://UI/Assets/Prompts/Prompts.png" type="Texture" id=1]

[resource]
atlas = ExtResource( 1 )
region = Rect2( %s, %s, 9, 10 )
"""

file_names = """
tick
1
2
3
4
5
6
7
8
9
0
minus
plus
backspace
tab
q
w
e
r
t
y
u
i
o
p
lsqaurebracket
rsqaurebracket
backslash
caps
a
s
d
f
g
h
j
k
l
semicolon
atosphrethe
enter
__skip__
lshift
z
x
c
v
b
n
m
comma
period
forwardslash
rshift
up
__skip__
lctrl
lalt
space
ralt
rctrl
left
down
right
escape
pad_x
pad_a
pad_b
pad_y
dpad_up
dpad_right
dpad_down
dpad_left
ljoy_down
rjoy_down
controller_r
controller_l
controller_zr
controller_zl
mouse_right
mouse_left
mouse_middle
__skip__
__skip__
""".split()

tex_width = 126
tex_height = 60
button_width = 9
button_height = 10
name = 0

for y in range(int(tex_height / button_height)):
    for x in range(int(tex_width / button_width)):
        file_name = file_names[name] + "_kb.tres"
        name += 1
        if file_name.startswith("__skip__"): continue

        file = open(file_name, "w")

        key_x = x * button_width
        key_y = y * button_height

        file.write(file_contents % (str(key_x), str(key_y)))
        file.close()

        print("%s at (%s, %s)" % (file_name, str(key_x), str(key_y)))