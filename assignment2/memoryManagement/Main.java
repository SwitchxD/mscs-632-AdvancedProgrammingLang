class Main {
    public static void main(String[] args) {
        Runtime rt = Runtime.getRuntime();

        System.out.println("--- Before allocation ---");
        System.out.println("Used memory: " + (rt.totalMemory() - rt.freeMemory()) / 1024 + " KB");

        // Allocate a large array
        int[] data = new int[100000];
        for (int i = 0; i < data.length; i++) data[i] = i;

        System.out.println("--- After allocation ---");
        System.out.println("Used memory: " + (rt.totalMemory() - rt.freeMemory()) / 1024 + " KB");

        // Remove reference — object becomes eligible for GC
        data = null;
        System.gc();

        System.out.println("--- After GC ---");
        System.out.println("Used memory: " + (rt.totalMemory() - rt.freeMemory()) / 1024 + " KB");
    }
}