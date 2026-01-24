package HD;

//Parche seguro para 1920x1080 - limita ZoomMap a 1600px
//@category Patching
//@menupath Tools.Patch Safe Resolution
//@description Permite 1920x1080 limitando el ZoomMap interno a 1600px

import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.mem.Memory;
import ghidra.program.model.listing.Listing;
import ghidra.program.model.listing.Instruction;
import ghidra.program.model.mem.MemoryBlock;

public class PatchSafeResolution extends GhidraScript {

    /*
     * ESTRATEGIA:
     * El buffer del ZoomMap solo soporta 1600 pixeles de ancho.
     * En lugar de intentar expandirlo (lo cual causa crashes),
     * limitamos el parametro de ancho que se pasa a BuildZoomMap.
     *
     * Esto significa que el minimapa/zoommap no usara los 320 pixeles
     * extra de la derecha, pero el juego funcionara sin crashes.
     *
     * Ubicacion del parche: 0x454916
     * Codigo original:
     *   454916: dec eax              ; eax = width - 1
     *   454917: mov [ebp+4], esi
     *   45491a: dec ecx              ; ecx = height - 1
     *   45491b: mov [ebp+8], eax
     *
     * Nuevo codigo (usando code cave):
     *   454916: jmp code_cave
     *   45491b: nop nop nop
     *
     * Code cave (en 0x743FC0, zona de .data con zeros):
     *   cmp eax, 0x640         ; si width > 1600
     *   jle skip
     *   mov eax, 0x640         ; limitar a 1600
     *   skip:
     *   dec eax
     *   mov [ebp+4], esi
     *   dec ecx
     *   mov [ebp+8], eax
     *   jmp 0x45491e           ; volver
     */

    private static final long PATCH_ADDR = 0x454916L;
    private static final long CODE_CAVE_ADDR = 0x743FC0L;
    private static final long RETURN_ADDR = 0x45491EL;
    private static final int MAX_WIDTH = 0x640; // 1600

    @Override
    public void run() throws Exception {
        println("============================================================");
        println("PARCHE SEGURO PARA 1920x1080");
        println("============================================================");
        println("");
        println("Este parche permite usar 1920x1080 limitando el ZoomMap");
        println("interno a 1600 pixeles para evitar crashes.");
        println("");

        Memory memory = currentProgram.getMemory();
        Listing listing = currentProgram.getListing();

        // Verificar bytes originales
        Address patchAddr = toAddr(PATCH_ADDR);
        byte[] origBytes = new byte[8];
        memory.getBytes(patchAddr, origBytes);

        byte[] expected = new byte[] {
            0x48,                       // dec eax
            (byte)0x89, 0x75, 0x04,     // mov [ebp+4], esi
            0x49,                       // dec ecx
            (byte)0x89, 0x45, 0x08      // mov [ebp+8], eax
        };

        println("[*] Verificando codigo original en 0x" + Long.toHexString(PATCH_ADDR) + "...");
        println("    Encontrado: " + bytesToHex(origBytes));
        println("    Esperado:   " + bytesToHex(expected));

        boolean isOriginal = java.util.Arrays.equals(origBytes, expected);
        boolean isPatched = (origBytes[0] == (byte)0xE9); // JMP

        if (isPatched) {
            println("");
            println("[!] El codigo ya esta parcheado (JMP detectado)");
            if (!askYesNo("Re-aplicar?", "El parche ya parece estar aplicado. Re-aplicar?")) {
                return;
            }
        } else if (!isOriginal) {
            println("");
            println("[!] Bytes no coinciden con el original");
            if (!askYesNo("Continuar?", "Los bytes no coinciden. Continuar de todos modos?")) {
                return;
            }
        } else {
            println("    OK - Codigo original detectado");
        }

        // Verificar code cave
        Address codeCaveAddr = toAddr(CODE_CAVE_ADDR);
        byte[] caveCheck = new byte[30];
        memory.getBytes(codeCaveAddr, caveCheck);

        boolean caveEmpty = true;
        for (byte b : caveCheck) {
            if (b != 0) {
                caveEmpty = false;
                break;
            }
        }

        println("");
        println("[*] Verificando code cave en 0x" + Long.toHexString(CODE_CAVE_ADDR) + "...");
        if (caveEmpty) {
            println("    OK - Code cave disponible (zeros)");
        } else {
            println("    Code cave contiene datos: " + bytesToHex(caveCheck));
            if (!askYesNo("Sobrescribir?", "El code cave no esta vacio. Sobrescribir?")) {
                return;
            }
        }

        // Calcular saltos
        long jmpToCave = CODE_CAVE_ADDR - (PATCH_ADDR + 5);
        long jmpBack = RETURN_ADDR - (CODE_CAVE_ADDR + 25); // 25 = tamano del code cave sin jmp final

        println("");
        println("[*] Calculando saltos:");
        println("    JMP to cave: " + jmpToCave);
        println("    JMP back:    " + jmpBack);

        // Construir trampolin (8 bytes)
        byte[] trampolin = new byte[] {
            (byte)0xE9,                              // jmp rel32
            (byte)(jmpToCave & 0xFF),
            (byte)((jmpToCave >> 8) & 0xFF),
            (byte)((jmpToCave >> 16) & 0xFF),
            (byte)((jmpToCave >> 24) & 0xFF),
            (byte)0x90, (byte)0x90, (byte)0x90       // nop nop nop
        };

        // Construir code cave (25 bytes + 5 bytes jmp = 30 bytes)
        byte[] codeCave = new byte[] {
            // cmp eax, 0x640 (5 bytes)
            0x3D,
            (byte)(MAX_WIDTH & 0xFF),
            (byte)((MAX_WIDTH >> 8) & 0xFF),
            0x00, 0x00,

            // jle +5 (2 bytes) - saltar si <= 1600
            0x7E, 0x05,

            // mov eax, 0x640 (5 bytes) - limitar a 1600
            (byte)0xB8,
            (byte)(MAX_WIDTH & 0xFF),
            (byte)((MAX_WIDTH >> 8) & 0xFF),
            0x00, 0x00,

            // dec eax (1 byte)
            0x48,

            // mov [ebp+0x4], esi (3 bytes)
            (byte)0x89, 0x75, 0x04,

            // dec ecx (1 byte)
            0x49,

            // mov [ebp+0x8], eax (3 bytes)
            (byte)0x89, 0x45, 0x08,

            // jmp back (5 bytes)
            (byte)0xE9,
            (byte)(jmpBack & 0xFF),
            (byte)((jmpBack >> 8) & 0xFF),
            (byte)((jmpBack >> 16) & 0xFF),
            (byte)((jmpBack >> 24) & 0xFF)
        };

        println("");
        println("[*] Trampolin (" + trampolin.length + " bytes): " + bytesToHex(trampolin));
        println("[*] Code cave (" + codeCave.length + " bytes): " + bytesToHex(codeCave));

        if (!askYesNo("Aplicar", "Aplicar parche seguro para 1920x1080?")) {
            println("Cancelado.");
            return;
        }

        int txId = currentProgram.startTransaction("Patch Safe Resolution");

        try {
            // Hacer .data ejecutable
            println("");
            println("[*] Configurando permisos de memoria...");
            MemoryBlock dataBlock = memory.getBlock(codeCaveAddr);
            if (dataBlock != null && !dataBlock.isExecute()) {
                dataBlock.setExecute(true);
                println("    Seccion " + dataBlock.getName() + " marcada como ejecutable");
            }

            // Limpiar codigo existente
            listing.clearCodeUnits(patchAddr, patchAddr.add(7), false);
            listing.clearCodeUnits(codeCaveAddr, codeCaveAddr.add(codeCave.length - 1), false);

            // Escribir trampolin
            println("[*] Escribiendo trampolin...");
            memory.setBytes(patchAddr, trampolin);

            // Escribir code cave
            println("[*] Escribiendo code cave...");
            memory.setBytes(codeCaveAddr, codeCave);

            // Re-desensamblar
            ghidra.app.cmd.disassemble.DisassembleCommand cmd1 =
                new ghidra.app.cmd.disassemble.DisassembleCommand(patchAddr, null, true);
            cmd1.applyTo(currentProgram);

            ghidra.app.cmd.disassemble.DisassembleCommand cmd2 =
                new ghidra.app.cmd.disassemble.DisassembleCommand(codeCaveAddr, null, true);
            cmd2.applyTo(currentProgram);

            currentProgram.endTransaction(txId, true);

            println("");
            println("============================================================");
            println("PARCHE APLICADO EXITOSAMENTE!");
            println("============================================================");
            println("");
            println("El juego ahora funcionara a 1920x1080.");
            println("El ZoomMap interno esta limitado a 1600px de ancho.");
            println("");
            println("IMPORTANTE: Antes de exportar, verifica en Window -> Memory Map");
            println("que la seccion .data tenga el flag X (ejecutable).");
            println("");
            println("Exporta: File -> Export Program -> Format: PE");

        } catch (Exception e) {
            currentProgram.endTransaction(txId, false);
            printerr("ERROR: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    private String bytesToHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < bytes.length; i++) {
            if (i > 0) sb.append(" ");
            sb.append(String.format("%02X", bytes[i] & 0xFF));
        }
        return sb.toString();
    }
}
