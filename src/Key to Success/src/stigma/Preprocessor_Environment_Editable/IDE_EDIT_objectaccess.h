/********************************************************************************\
**                                                                              **
**  Copyright (C) 2008 Josh Ventura                                             **
**                                                                              **
**  This file is a part of the ENIGMA Development Environment.                  **
**                                                                              **
**                                                                              **
**  ENIGMA is free software: you can redistribute it and/or modify it under the **
**  terms of the GNU General Public License as published by the Free Software   **
**  Foundation, version 3 of the license or any later version.                  **
**                                                                              **
**  This application and its source code is distributed AS-IS, WITHOUT ANY      **
**  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   **
**  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more       **
**  details.                                                                    **
**                                                                              **
**  You should have recieved a copy of the GNU General Public License along     **
**  with this code. If not, see <http://www.gnu.org/licenses/>                  **
**                                                                              **
**  ENIGMA is an environment designed to create games and other programs with a **
**  high-level, fully compilable language. Developers of ENIGMA or anything     **
**  associated with ENIGMA are in no way responsible for its users or           **
**  applications created by its users, or damages caused by the environment     **
**  or programs made in the environment.                                        **
**                                                                              **
\********************************************************************************/

//This file was generated by the ENIGMA Development Environment.
//Editing it is a sign of a certain medical condition. We're not sure which one.

// Depending on how many times your game accesses variables via OBJECT.varname, this file may be empty.

namespace enigma
{
  object_locals ldummy;
  object_locals *glaccess(int x)
  {
    object_locals* ri = (object_locals*)fetch_instance_by_int(x);
    return ri ? ri : &ldummy;
  }

  var &map_var(std::map<string, var> **vmap, string str)
  {
      if (*vmap == NULL)
        *vmap = new std::map<string, var>();
      if ((*vmap)->find(str) == (*vmap)->end())
        (*vmap)->insert(std::pair<string, var>(str, 0));
      return ((*vmap)->find(str))->second;
  }

  var dummy_0; // Referenced by 3 accessors
  var  &varaccess__lives(int x)
  {
    object_basic *inst = fetch_instance_by_int(x);
    if (inst) switch (inst->object_index)
    {
      case global: return ((ENIGMA_global_structure*)ENIGMA_global_instance)->_lives;
      default: return map_var(&(((enigma::object_locals*)inst)->vmap), "_lives");
    }
    return dummy_0;
  }
  var  &varaccess_dir(int x)
  {
    object_basic *inst = fetch_instance_by_int(x);
    if (inst) switch (inst->object_index)
    {
      case obj_background_shark: return ((OBJ_obj_background_shark*)inst)->dir;
      case obj_baddie_acid_man: return ((OBJ_obj_baddie_acid_man*)inst)->dir;
      case obj_baddie_shark: return ((OBJ_obj_baddie_shark*)inst)->dir;
      case global: return ((ENIGMA_global_structure*)ENIGMA_global_instance)->dir;
      default: return map_var(&(((enigma::object_locals*)inst)->vmap), "dir");
    }
    return dummy_0;
  }
  var  &varaccess_level_previous(int x)
  {
    object_basic *inst = fetch_instance_by_int(x);
    if (inst) switch (inst->object_index)
    {
      case global: return ((ENIGMA_global_structure*)ENIGMA_global_instance)->level_previous;
      default: return map_var(&(((enigma::object_locals*)inst)->vmap), "level_previous");
    }
    return dummy_0;
  }
} // namespace enigma
