
#include <stdio.h>
#include "../lib/lua/src/lua.h"
#include "../lib/lua/src/lualib.h"
#include "../lib/lua/src/lauxlib.h"

void lua_example_dofile(void) {
  lua_State *L = luaL_newstate();

  luaL_openlibs(L);
  luaL_dofile(L, "./scripts/factorial.lua");

  lua_close(L);
}

void lua_example_getvar(void) {
  lua_State *L = luaL_newstate();

  luaL_dostring(L, "some_var = 486");

  lua_getglobal(L, "some_var");

  lua_Number some_var = lua_tonumber(L, -1);

  printf("the some_var from lua is %d\n", (int)some_var);

  lua_close(L);
}

void lua_example_stack(void) {
  lua_State *L = luaL_newstate();

  lua_pushnumber(L, 286);
  lua_pushnumber(L, 386);
  lua_pushnumber(L, 486);

  lua_Number n;

  n = lua_tonumber(L, -1);

  printf("the top of the stack is %d\n", (int)n);

  lua_close(L);
}

void lua_example_call_lua_function(void) {
  lua_State *L = luaL_newstate();

  luaL_dofile(L, "./scripts/pythagras.lua");
  lua_getglobal(L, "pythagras");

  if (lua_isfunction(L, -1)) {
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 4);

    int NUM_ARGS = 2;
    int NUM_RETURNS = 1;

    lua_pcall(L, NUM_ARGS, NUM_RETURNS, 0);

    lua_Number res = lua_tonumber(L, -1);

    printf("the result of the pythagras(3, 4) is %d\n", (int)res);
  }

  lua_close(L);
}

int native_pythagras(lua_State *L) {
  lua_Number b = lua_tonumber(L, -1);
  lua_Number a = lua_tonumber(L, -2);

  lua_pushnumber(L, a * a + b * b);
  return 1;
}

void lua_example_call_c_function(void) {
  lua_State *L = luaL_newstate();

  lua_pushcfunction(L, native_pythagras);
  lua_setglobal(L, "native_pythagras");

  luaL_openlibs(L);
  luaL_dofile(L, "./scripts/native_pythagras.lua");

  lua_close(L);
}

typedef struct {
  int x;
  int y;
  int width;
  int height;
} rectangle;

int change_rectangle_size(lua_State *L) {
  lua_Number height = lua_tonumber(L, -1);
  lua_Number width = lua_tonumber(L, -2);
  rectangle* r = (rectangle*) lua_touserdata(L, -3); 
  r->width = width;
  r->height = height;
  return 0;
}

int create_rectangle(lua_State *L) {
  rectangle* r = (rectangle*) lua_newuserdata(L, sizeof(rectangle)); 
  r->x = 0;
  r->y = 0;
  r->width = 0;
  r->height = 0;
  return 1;
}

void lua_example_userdata(void) {
  lua_State *L = luaL_newstate();

  lua_pushcfunction(L, create_rectangle);
  lua_setglobal(L, "create_rectangle");

  lua_pushcfunction(L, change_rectangle_size);
  lua_setglobal(L, "change_rectangle_size");

  luaL_dofile(L, "./scripts/rectangle.lua");

  lua_getglobal(L, "square");

  if (lua_isuserdata(L, -1)) {
    rectangle* r = (rectangle*) lua_touserdata(L, -1); 

    printf("the size of the rectangle is (%d, %d)\n", r->width, r->height);
  }

  lua_close(L);
}

void lua_example_table(void) {
  lua_State *L = luaL_newstate();

  luaL_dofile(L, "./scripts/config_table.lua");
  lua_getglobal(L, "config_table");
  lua_getfield(L, -1, "width");

  lua_Number width = lua_tonumber(L, -1);

  printf("the height of the config is %d\n", (int)width);

  lua_close(L);
}

int main(int argc, char* argv[]) {
  lua_example_dofile();
  // lua_example_getvar();
  // lua_example_stack();
  // lua_example_call_lua_function();
  // lua_example_call_c_function();
  // lua_example_userdata();
  // lua_example_table();
  return 0;
}
