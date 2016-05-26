package net.bull.javamelody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * This class is just a shim to wrap around the package-private javamelody
 * HeapHistogram class, so that we can access heap histo data from anywhere.
 */
public class PublicHeapHistogram {
    public static class PublicClassInfo {
        private final HeapHistogram.ClassInfo classInfo;

        PublicClassInfo(HeapHistogram.ClassInfo classInfo) {
            this.classInfo = classInfo;
        }

        public long getBytes() {
            return this.classInfo.getBytes();
        }

        public long getInstancesCount() {
            return this.classInfo.getInstancesCount();
        }

        public String getName() {
            return this.classInfo.getName();
        }

        public String getSource() {
            return this.classInfo.getSource();
        }

        public boolean isPermGen() {
            return this.classInfo.isPermGen();
        }
    }

    public static List<PublicClassInfo> publicHeapHisto() throws Exception {
        HeapHistogram h = VirtualMachine.createHeapHistogram();

        List<PublicClassInfo> rv = new ArrayList<>();
        for (HeapHistogram.ClassInfo ci : h.getHeapHistogram()) {
            rv.add(new PublicClassInfo(ci));
        }
        return rv;
    }

    public static Map<String, PublicClassInfo> publicHeapHistoMap() throws Exception {
        List<PublicClassInfo> publicHisto = publicHeapHisto();
        Map<String, PublicClassInfo> rv = new HashMap<>();
        for (PublicClassInfo ci : publicHisto) {
            rv.put(ci.getName(), ci);
        }
        return rv;
    }
}
