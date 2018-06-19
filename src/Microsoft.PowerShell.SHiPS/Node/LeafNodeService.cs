using System.Linq;
using System.Management.Automation.Provider;
using CodeOwls.PowerShell.Paths;
using CodeOwls.PowerShell.Provider.PathNodeProcessors;
using CodeOwls.PowerShell.Provider.PathNodes;

namespace Microsoft.PowerShell.SHiPS
{
    /// <summary>
    /// Defines actions that applies to a SHiPSLeaf node.
    /// </summary>
    internal class LeafNodeService : PathNodeBase, IGetItemContent
    {
        private readonly SHiPSLeaf _shipsLeaf;
        private static readonly string _leaf = ".";

        internal LeafNodeService(object leafObject)
        {
            _shipsLeaf = leafObject as SHiPSLeaf;
        }

        public override IPathValue GetNodeValue()
        {
            return new LeafPathValue(_shipsLeaf, Name);
        }

        public override string ItemMode
        {
            get {return _leaf; }
        }

        public override string Name
        {
            get { return _shipsLeaf.Name; }
        }


        public IContentReader GetContentReader(IProviderContext context)
        {
            //find the current parent node 
            var item = this._shipsLeaf;
            if (item == null)
            {
                return null;
            }

            // Set the ProviderContext as the DynamicParameters and Filter objects will be used in the
            // PowerShell module's GetChildItem().
            // If dynamic parameters are used, then SHiPS is not using cache. 
            // ProviderContext has to be set right now because context.NeedRefresh uses it.
            item.SHiPSProviderContext.Set(context);

            var results = PSScriptRunner.InvokeScriptBlock(context, Constants.GetContentReader, _shipsLeaf)?.ToList();
            var res = results.First() as IContentReader;
            return res;
        }

        public object GetContentReaderDynamicParameters(IProviderContext context)
        {
            return null;
        }
    }
}
