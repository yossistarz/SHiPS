using System;
using System.Collections.Concurrent;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Management.Automation.Provider;
using CodeOwls.PowerShell.Paths;
using CodeOwls.PowerShell.Provider.PathNodeProcessors;
using CodeOwls.PowerShell.Provider.PathNodes;

namespace Microsoft.PowerShell.SHiPS
{
    /// <summary>
    /// Defines actions that applies to a SHiPSLeaf node.
    /// </summary>
    internal class LeafNodeService : NodeServiceBase//, IGetItemContent
    {
        private readonly SHiPSLeaf _shipsLeaf;
        private static readonly string _leaf = ".";

        protected override SHiPSBase Item => _shipsLeaf;

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


        //public IContentReader GetContentReader(IProviderContext context)
        //{
        //    //find the current parent node 
        //    var item = this._shipsLeaf;
        //    if (item == null)
        //    {
        //        return null;
        //    }

        //    // Set the ProviderContext as the DynamicParameters and Filter objects will be used in the
        //    // PowerShell module's GetChildItem().
        //    // If dynamic parameters are used, then SHiPS is not using cache. 
        //    // ProviderContext has to be set right now because context.NeedRefresh uses it.
        //    item.SHiPSProviderContext.Set(context);

        //    var results = PSScriptRunner.InvokeScriptBlock(context, Constants.GetContentReader, _shipsLeaf)?.ToList();
        //    var res = results.First() as IContentReader;
        //    return res;
        //}

        //public object GetContentReaderDynamicParameters(IProviderContext context)
        //{
        //    var errors = new ConcurrentBag<ErrorRecord>();

        //    var parameters = PSScriptRunner.CallPowerShellScript(
        //        _shipsLeaf,
        //        context,
        //        (context.Drive as SHiPSDrive).PowerShellInstance,
        //        null,
        //        Constants.GetContentDynamicParameters,
        //        PSScriptRunner.output_DataAdded,
        //        (sender, e) => PSScriptRunner.error_DataAdded(sender, e, errors));

        //    if (errors.WhereNotNull().Any())
        //    {
        //        var error = errors.FirstOrDefault();
        //        var message = Environment.NewLine;
        //        message += error.ErrorDetails == null ? error.Exception.Message : error.ErrorDetails.Message;
        //        throw new InvalidDataException(message);
        //    }

        //    return parameters != null ? parameters.FirstOrDefault() : null;
        //}
    }
}
