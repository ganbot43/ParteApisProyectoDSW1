using apiModeloExamen.Contracts.Entities;

namespace apiModeloExamen.Repositories.Interfaces
{
    public interface ICategoriaRepository
    {
        Task<IEnumerable<Categoria>> ListarAsync();
        Task<int> InsertarAsync(Categoria categoria);
        Task EditarAsync(Categoria categoria);
    }
}
