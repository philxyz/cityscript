-- Protección de Props Discreto por philxyz
--
-- Archivo de cadenas de texto de interfaz de usuario en castellano
--
-- Este archivo se incluye cl_upp.lua - y se define el texto que aparece
-- para asuntos de protección de props en el juego.
--
-- == PARA USAR OTRA LENGUAJE QUE YA EXISTE ==
-- 1) Sigue pasos 3 y 4 en la sección que sigue.
--
-- == PARA AÑADIR UN LENGUAJE NUEVO ==
-- 1) Copiar este archivo para crear uno nuevo para su nuevo lenguaje,
--    por ejemplo: lenguaje_esperanto_upp.lua
--
-- 2) Editar las líneas "language.Add" en la copia nueva para incluir texto
--		que corresponde a ese lenguaje.
--
-- 3) Editar cl_upp.lua para incluir ese en vez de este.
--
-- 4) Reemplezar referencias a este archivo y reemplezarles con referencias a
--		la nueva. Las referencias están en los archivos:
--		./gamemode/cl_upp.lua
--		./gamemode/client_resources.lua
--		./gamemode/shared.lua
--
-- == ¡IMPORTANTE! ==
-- Asegurar de que el contenido de este archivo está en formato UTF-8 (sin BOM)

-- == Cadenas de texto especifico al lenguaje de este archivo ==

language.Add("upp.prop_protection", "Protección de Props")
language.Add("upp.admin_tools", "Herramientas Admin")
language.Add("upp.my_props", "Mis Props")
language.Add("upp.trusted_players", "Jugadores de Confianza")
language.Add("upp.cleanup_time", "Minutos hasta eliminación en D/C")
language.Add("upp.remove_props", "Eliminar Props...")
language.Add("upp.remove_my_props", "Eliminar mis props")
language.Add("upp.for_all_players", "Todos")
language.Add("upp.for_player", "Perteneciente al jugador")
language.Add("upp.prop_cleanup", "Un admin ha eliminado tus props.")
language.Add("upp.prop_cleanup_you", "Tus props han sido eliminados.")
language.Add("upp.prop_cleanup_all", "Un admin ha eliminado todos tus props.")
language.Add("upp.ent_cleanup", "Un admin ha eliminado tus entidades.")
language.Add("upp.ent_cleanup_all", "Un admin ha eliminado todos tus entidades.")
language.Add("upp.prop_disallowed", "Este prop no se permite.")
language.Add("upp.sents_disallowed", "No se permite desove de SENT.")
language.Add("upp.ragdolls_disallowed", "No se permite desovar de muñeca de trapo.")
language.Add("upp.effects_disallowed", "No se permite desove de efectos.")
language.Add("upp.sweps_disallowed", "No se permite desove de SWEP.")
language.Add("upp.npcs_disallowed", "No se permite desove de NPC.")
language.Add("upp.add_trusted", "Añadir un jugador...")
language.Add("upp.remove_selected", "Eliminar jugador seleccionado")
language.Add("upp.name_now", "Nombre Actual")
language.Add("upp.name_when_added", "Nombre al Añadir")
language.Add("upp.s64id", "Steam64ID")
language.Add("upp.player_already_trusted", "Este jugador ya está en la lista.")
language.Add("upp.allowthese", "Permitir desovar")
language.Add("upp.disallowthese", "Prohibir desovar")
