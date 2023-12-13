package dmall.framework.cache;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.config.CacheConfiguration;
import net.sf.ehcache.config.Configuration;
import net.sf.ehcache.config.DiskStoreConfiguration;
import net.sf.ehcache.config.FactoryConfiguration;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;

public class CacheManagerFactoryBean implements FactoryBean<CacheManager>, InitializingBean {
    @Value("${cache.default.eternal}")
    private boolean eternal;
    @Value("${cache.default.maxElementsInMemory}")
    private int maxElementsInMemory;
    @Value("${cache.default.overflowToDisk}")
    private boolean overflowToDisk ;
    @Value("${cache.default.diskPersistent}")
    private boolean diskPersistent;
    @Value("${cache.default.timeToIdleSeconds}")
    private long timeToIdleSeconds;
    @Value("${cache.default.timeToLiveSeconds}")
    private long timeToLiveSeconds;
    @Value("${cache.default.memoryStoreEvictionPolicy}")
    private String memoryStoreEvictionPolicy;


    @Value("${cache.common.name}")
    private String commonName;
    @Value("${cache.common.eternal}")
    private boolean  commonEternal;
    @Value("${cache.common.maxElementsInMemory}")
    private int commonMaxElementsInMemory;
    @Value("${cache.common.overflowToDisk}")
    private boolean commonOverflowToDisk ;
    @Value("${cache.common.diskPersistent}")
    private boolean commonDiskPersistent;
    @Value("${cache.common.timeToIdleSeconds}")
    private long commonTimeToIdleSeconds;
    @Value("${cache.common.timeToLiveSeconds}")
    private long commonTimeToLiveSeconds;
    @Value("${cache.common.memoryStoreEvictionPolicy}")
    private String commonMemoryStoreEvictionPolicy;

    @Value("${cache.bootstrapAsynchronously}")
    private String bootstrapAsynchronously;
    @Value("${cache.maximumChunkSizeBytes}")
    private String maximumChunkSizeBytes;
    @Value("${cache.peerDiscovery}")
    private String peerDiscovery;
    @Value("${cache.multicastGroupAddress}")
    private String multicastGroupAddress;
    @Value("${cache.multicastGroupPort}")
    private String multicastGroupPort;
    @Value("${cache.timeToLive}")
    private String timeToLive;
    @Value("${cache.port}")
    private String port;
    @Value("${cache.socketTimeoutMillis}")
    private String socketTimeoutMillis;

    private CacheManager cacheManager;


    public static final class CacheManagerPeerProviderFactoryConfiguration extends
            FactoryConfiguration<CacheManagerPeerProviderFactoryConfiguration> {
    }

    public static final class CacheManagerPeerListenerFactoryConfiguration extends
            FactoryConfiguration<CacheManagerPeerListenerFactoryConfiguration> {
    }

    private Configuration createConfig(){
        Configuration configuration = new Configuration();
        configuration.diskStore(new DiskStoreConfiguration().path("java.io.tmpdir"));

        CacheManagerPeerProviderFactoryConfiguration cacheManagerPeerProviderFactory;
        cacheManagerPeerProviderFactory = new CacheManagerPeerProviderFactoryConfiguration();
        cacheManagerPeerProviderFactory.setClass("net.sf.ehcache.distribution.RMICacheManagerPeerProviderFactory");
        cacheManagerPeerProviderFactory.setProperties(
                "peerDiscovery=".concat(peerDiscovery)
                        .concat(",multicastGroupAddress=").concat(multicastGroupAddress)
                        .concat(",multicastGroupPort=").concat(multicastGroupPort)
                        .concat(",timeToLive=").concat(timeToLive)
        );
        CacheManagerPeerListenerFactoryConfiguration cacheManagerPeerListenerFactory;
        cacheManagerPeerListenerFactory = new CacheManagerPeerListenerFactoryConfiguration();
        cacheManagerPeerListenerFactory.setClass("net.sf.ehcache.distribution.RMICacheManagerPeerListenerFactory");
        cacheManagerPeerListenerFactory.setProperties(
                "port=".concat(port).concat(", socketTimeoutMillis=").concat(socketTimeoutMillis)
        );
        configuration.addCacheManagerPeerProviderFactory(cacheManagerPeerProviderFactory);
        configuration.addCacheManagerPeerListenerFactory(cacheManagerPeerListenerFactory);
        return configuration;
    }

    private CacheConfiguration createDefaultConfig(){
        return new CacheConfiguration().eternal(false)
                .eternal(eternal)
                .maxElementsInMemory(maxElementsInMemory)
                .overflowToOffHeap(overflowToDisk)
                .diskPersistent(diskPersistent)
                .timeToIdleSeconds(timeToIdleSeconds)
                .timeToLiveSeconds(timeToLiveSeconds)
                .memoryStoreEvictionPolicy(memoryStoreEvictionPolicy);
    }

    private CacheConfiguration createCommonConfig(){
        CacheConfiguration.CacheEventListenerFactoryConfiguration eventListenerFactory;
        CacheConfiguration.BootstrapCacheLoaderFactoryConfiguration bootstrapCacheLoaderFactoryConfiguration;

        eventListenerFactory = new CacheConfiguration.CacheEventListenerFactoryConfiguration();
        bootstrapCacheLoaderFactoryConfiguration = new CacheConfiguration.BootstrapCacheLoaderFactoryConfiguration();

        eventListenerFactory.setClass("net.sf.ehcache.distribution.RMICacheReplicatorFactory");
        bootstrapCacheLoaderFactoryConfiguration.setClass("net.sf.ehcache.distribution.RMIBootstrapCacheLoaderFactory");
        bootstrapCacheLoaderFactoryConfiguration.setProperties(
                "bootstrapAsynchronously=".concat(bootstrapAsynchronously)
                        .concat(", maximumChunkSizeBytes=").concat(maximumChunkSizeBytes)
        );

        return new CacheConfiguration().eternal(false)
                .name(commonName)
                .eternal(commonEternal)
                .maxElementsInMemory(commonMaxElementsInMemory)
                .overflowToOffHeap(commonOverflowToDisk)
                .diskPersistent(commonDiskPersistent)
                .timeToIdleSeconds(commonTimeToIdleSeconds)
                .timeToLiveSeconds(commonTimeToLiveSeconds)
                .memoryStoreEvictionPolicy(commonMemoryStoreEvictionPolicy)
                .cacheEventListenerFactory(eventListenerFactory)
                .bootstrapCacheLoaderFactory(bootstrapCacheLoaderFactoryConfiguration);
    }

    private CacheManager createCacheManager() {
        CacheManager manager;
        Configuration configuration = createConfig();
        configuration.setDefaultCacheConfiguration(createDefaultConfig());
        manager = CacheManager.create(configuration);
        manager.addCache(new Cache(createCommonConfig()));
        return manager;
    }

    @Override
    public void afterPropertiesSet() {
        cacheManager = createCacheManager();
    }

    @Override
    public CacheManager getObject() {
        return this.cacheManager;
    }

    @Override
    public Class<? extends CacheManager> getObjectType() {
        return (this.cacheManager != null ? this.cacheManager.getClass() : CacheManager.class);
    }

    @Override
    public boolean isSingleton() {
        return true;
    }

}
